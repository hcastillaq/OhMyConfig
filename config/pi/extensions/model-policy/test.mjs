import test from 'node:test';
import assert from 'node:assert/strict';

import { getBlendedCost } from './pricing.ts';
import { classifySubagent } from './classifier.ts';
import { CircuitBreaker } from './breaker.ts';
import {
  qualifyModelForTiers,
  buildModelCandidates,
  groupAndSortTiers,
  resolveModelForTier
} from './models.ts';

test('1. Pricing Oracle - Blended Cost Calculation', () => {
  // Luna: 0.15 * 0.75 + 0.60 * 0.25 = 0.1125 + 0.15 = 0.2625
  const lunaCost = getBlendedCost('openai-codex', 'gpt-5.6-luna');
  assert.ok(lunaCost < 0.3, `Luna cost should be < 0.3, got ${lunaCost}`);

  // Sol: 5.0 * 0.75 + 20.0 * 0.25 = 3.75 + 5.0 = 8.75
  const solCost = getBlendedCost('openai-codex', 'gpt-5.6-sol');
  assert.ok(solCost > 7.0 && solCost < 10.0, `Sol cost should be ~8.75, got ${solCost}`);

  // Unknown flash model uses keyword heuristic
  const unknownFlash = getBlendedCost('custom', 'my-special-flash-model');
  assert.equal(unknownFlash, 0.25);
});

test('2. Subagent Classifier - Compound Engineering Agents', () => {
  // Scout -> FAST
  const scout = classifySubagent('scout');
  assert.equal(scout.tier, 'FAST');

  // ce-security-reviewer -> REASON
  const sec = classifySubagent('ce-security-reviewer', 'Security review persona');
  assert.equal(sec.tier, 'REASON');

  // ce-git-history-analyzer -> RESEARCH
  const git = classifySubagent('ce-git-history-analyzer', 'Analyze git history');
  assert.equal(git.tier, 'RESEARCH');

  // worker / implementer -> BUILD
  const worker = classifySubagent('worker');
  assert.equal(worker.tier, 'BUILD');

  // ce-architecture-strategist -> ARCHITECT
  const arch = classifySubagent('ce-architecture-strategist');
  assert.equal(arch.tier, 'ARCHITECT');

  // oracle -> ORACLE
  const oracle = classifySubagent('oracle');
  assert.equal(oracle.tier, 'ORACLE');

  // Tool-based classification for unknown agent
  const customBuilder = classifySubagent('custom-tool', '', ['write', 'bash']);
  assert.equal(customBuilder.tier, 'BUILD');

  // Unknown with no tools -> FAST (cheap by default)
  const unknown = classifySubagent('mystery-agent', '', []);
  assert.equal(unknown.tier, 'FAST');

  // Explicit user override wins
  const overridden = classifySubagent('scout', '', [], {
    scout: { tier: 'ORACLE' }
  });
  assert.equal(overridden.tier, 'ORACLE');
  assert.equal(overridden.ruleSource, 'override');
});

test('3. CircuitBreaker - Cooldown & Quota Error Detection', () => {
  const breaker = new CircuitBreaker(50); // 50ms for test
  assert.equal(breaker.isCoolingDown('openai-codex'), false);

  breaker.recordFailure('openai-codex');
  assert.equal(breaker.isCoolingDown('openai-codex'), true);

  // Error string detection
  assert.equal(breaker.detectQuotaError('Error: 429 Too Many Requests'), true);
  assert.equal(breaker.detectQuotaError('Rate limit exceeded for organization'), true);
  assert.equal(breaker.detectQuotaError('File not found: test.ts'), false);
});

test('4. Model Discovery & Tier Qualification', () => {
  const mockModels = [
    { provider: 'openai-codex', id: 'gpt-5.6-luna', contextWindow: 128000 },
    { provider: 'antigravity', id: 'gemini-3.8-flash', contextWindow: 1048576 },
    { provider: 'openai-codex', id: 'gpt-5.6-terra', reasoning: true, contextWindow: 128000 },
    { provider: 'openai-codex', id: 'gpt-5.6-sol', reasoning: true, contextWindow: 128000 },
    { provider: 'openai-codex', id: 'gpt-6-astra', reasoning: true, contextWindow: 128000 }
  ];

  const candidates = buildModelCandidates(mockModels);
  const tierMap = groupAndSortTiers(candidates);
  const breaker = new CircuitBreaker();

  // Tier FAST: Luna & Gemini Flash both qualify, but Gemini Flash (0.175) or Luna (0.26) sorted by cost
  const fastRes = resolveModelForTier('FAST', tierMap, breaker);
  assert.ok(fastRes.candidate !== null);
  assert.equal(fastRes.candidate.tier, 'FAST');

  // Tier BUILD: Gemini Flash or Terra
  const buildRes = resolveModelForTier('BUILD', tierMap, breaker);
  assert.ok(buildRes.candidate !== null);

  // Tier REASON: Terra
  const reasonRes = resolveModelForTier('REASON', tierMap, breaker);
  assert.ok(reasonRes.candidate !== null);
  assert.equal(reasonRes.candidate.id, 'gpt-5.6-terra');

  // Tier ARCHITECT: Sol
  const archRes = resolveModelForTier('ARCHITECT', tierMap, breaker);
  assert.ok(archRes.candidate !== null);
  assert.equal(archRes.candidate.id, 'gpt-5.6-sol');

  // Tier ORACLE: Astra
  const oracleRes = resolveModelForTier('ORACLE', tierMap, breaker);
  assert.ok(oracleRes.candidate !== null);
  assert.equal(oracleRes.candidate.id, 'gpt-6-astra');
});

test('5. Context Window Promotion for Massive Prompts (>30k tokens)', () => {
  const mockModels = [
    { provider: 'openai-codex', id: 'gpt-5.6-luna', contextWindow: 128000 },
    { provider: 'antigravity', id: 'gemini-3.8-flash', contextWindow: 1048576 }
  ];
  const candidates = buildModelCandidates(mockModels);
  const tierMap = groupAndSortTiers(candidates);
  const breaker = new CircuitBreaker();

  // Normal task -> Luna or Flash
  const normalRes = resolveModelForTier('RESEARCH', tierMap, breaker, 500);
  assert.ok(normalRes.candidate !== null);

  // Massive task (40,000 tokens) -> Promoted to Gemini Flash with 1M context
  const massiveRes = resolveModelForTier('RESEARCH', tierMap, breaker, 40000);
  assert.ok(massiveRes.candidate !== null);
  assert.equal(massiveRes.candidate.id, 'gemini-3.8-flash');
  assert.equal(massiveRes.ruleSource, 'context-promotion');
});

test('6. No Upward Escalation Fallback under Rate-Limits', () => {
  const mockModels = [
    { provider: 'openai-codex', id: 'gpt-5.6-terra', reasoning: true, contextWindow: 128000 },
    { provider: 'antigravity', id: 'gemini-3.8-flash', contextWindow: 1048576 },
    { provider: 'openai-codex', id: 'gpt-5.6-sol', reasoning: true, contextWindow: 128000 }
  ];
  const candidates = buildModelCandidates(mockModels);
  const tierMap = groupAndSortTiers(candidates);
  const breaker = new CircuitBreaker();

  // Initially REASON picks Terra
  const initial = resolveModelForTier('REASON', tierMap, breaker);
  assert.equal(initial.candidate.id, 'gpt-5.6-terra');

  // OpenAI fails with 429
  breaker.recordFailure('openai-codex');

  // Next REASON dispatch must NOT escalate to Sol; it must pick Gemini Flash from BUILD/downward
  const fallback = resolveModelForTier('REASON', tierMap, breaker);
  assert.equal(fallback.candidate.provider, 'antigravity');
  assert.equal(fallback.candidate.id, 'gemini-3.8-flash');
  assert.ok(fallback.cooldownAvoided.includes('openai-codex/gpt-5.6-terra'));
});

test('7. Config Tier Override', () => {
  const mockModels = [
    { provider: 'openai-codex', id: 'gpt-5.6-luna', contextWindow: 128000 },
    { provider: 'antigravity', id: 'gemini-3.8-flash', contextWindow: 1048576 }
  ];
  const candidates = buildModelCandidates(mockModels);
  const tierMap = groupAndSortTiers(candidates);
  const breaker = new CircuitBreaker();

  const config = {
    tiers: {
      FAST: 'openai-codex/gpt-5.6-luna'
    }
  };

  const res = resolveModelForTier('FAST', tierMap, breaker, 0, config);
  assert.equal(res.candidate.fullId, 'openai-codex/gpt-5.6-luna');
  assert.equal(res.ruleSource, 'override');
});
