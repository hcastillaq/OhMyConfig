import test from 'node:test';
import assert from 'node:assert/strict';

import { calculateModelCost } from './pricing.ts';
import { classifySubagent } from './classifier.ts';
import { CircuitBreaker } from './breaker.ts';
import {
  buildModelCandidates,
  groupAndSortTiers,
  resolveModelForTier
} from './models.ts';

test('1. Pricing Calculation - Native Pi Metadata', () => {
  // Model with input=0.15, output=0.60 -> 0.15 * 0.75 + 0.60 * 0.25 = 0.2625
  const cost1 = calculateModelCost({ cost: { input: 0.15, output: 0.60 } });
  assert.equal(cost1, 0.2625);

  // Model with input=5.0, output=20.0 -> 5.0 * 0.75 + 20.0 * 0.25 = 8.75
  const cost2 = calculateModelCost({ cost: { input: 5.0, output: 20.0 } });
  assert.equal(cost2, 8.75);

  // Local model without cost metadata returns 0
  const freeCost = calculateModelCost({});
  assert.equal(freeCost, 0);
});

test('2. Subagent Classifier - Compound Engineering Roles', () => {
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

  // Tool-based classification for custom agent
  const customBuilder = classifySubagent('custom-tool', '', ['write', 'bash']);
  assert.equal(customBuilder.tier, 'BUILD');

  // Unknown with no tools -> FAST (cheap by default)
  const unknown = classifySubagent('mystery-agent', '', []);
  assert.equal(unknown.tier, 'FAST');

  // Subagents containing 'spec' inside other words must NOT trigger ARCHITECT
  const inspector = classifySubagent('code-inspector', 'Inspect code quality', ['read', 'grep']);
  assert.notEqual(inspector.tier, 'ARCHITECT', 'inspector must not be ARCHITECT');
  assert.equal(inspector.tier, 'RESEARCH');

  const specialist = classifySubagent('pattern-specialist', 'Analyze patterns', ['read', 'grep']);
  assert.notEqual(specialist.tier, 'ARCHITECT', 'specialist must not be ARCHITECT');
  assert.equal(specialist.tier, 'RESEARCH');

  // Explicit user override wins
  const overridden = classifySubagent('scout', '', [], {
    scout: { tier: 'ORACLE' }
  });
  assert.equal(overridden.tier, 'ORACLE');
  assert.equal(overridden.ruleSource, 'override');
});

test('3. CircuitBreaker - Cooldown & Quota Error Detection', () => {
  const breaker = new CircuitBreaker(50);
  assert.equal(breaker.isCoolingDown('openai-codex'), false);

  breaker.recordFailure('openai-codex');
  assert.equal(breaker.isCoolingDown('openai-codex'), true);

  // Error string detection with isError = true
  assert.equal(breaker.detectQuotaError('Error: 429 Too Many Requests', true), true);
  assert.equal(breaker.detectQuotaError('Rate limit exceeded for organization', true), true);
  assert.equal(breaker.detectQuotaError('File not found: test.ts', true), false);

  // False positive immunity: When isError = false (successful code execution), must return false!
  assert.equal(breaker.detectQuotaError('Fixed issue #429 and TypeScript overloaded method', false), false);
});

test('4. Dynamic Model Discovery & Relative Tiering (Zero Hardcoded Models)', () => {
  // Realistic heterogeneous registry with models from different providers
  const mockModels = [
    { provider: 'antigravity', id: 'gemini-3.8-flash', cost: { input: 0.10, output: 0.40 }, reasoning: false, contextWindow: 1048576 }, // cost: 0.175
    { provider: 'openai-codex', id: 'gpt-5.6-luna', cost: { input: 0.15, output: 0.60 }, reasoning: false, contextWindow: 128000 },    // cost: 0.2625
    { provider: 'openai-codex', id: 'gpt-5.6-terra', cost: { input: 2.50, output: 10.00 }, reasoning: true, contextWindow: 128000 },   // cost: 4.375
    { provider: 'openai-codex', id: 'gpt-5.6-sol', cost: { input: 5.00, output: 20.00 }, reasoning: true, contextWindow: 128000 },     // cost: 8.75
    { provider: 'openai-codex', id: 'gpt-6-astra', cost: { input: 15.00, output: 60.00 }, reasoning: true, contextWindow: 128000 }     // cost: 26.25
  ];

  const candidates = buildModelCandidates(mockModels);
  const tierMap = groupAndSortTiers(candidates);
  const breaker = new CircuitBreaker();

  // Tier FAST: Lowest cost standard model (Gemini Flash at $0.175 < Luna at $0.2625)
  const fastRes = resolveModelForTier('FAST', tierMap, breaker);
  assert.ok(fastRes.candidate !== null);
  assert.equal(fastRes.candidate.id, 'gemini-3.8-flash');

  // Tier RESEARCH: Largest context window at low cost (Gemini Flash with 1M context)
  const researchRes = resolveModelForTier('RESEARCH', tierMap, breaker);
  assert.ok(researchRes.candidate !== null);
  assert.equal(researchRes.candidate.id, 'gemini-3.8-flash');

  // Tier BUILD: Standard execution model
  const buildRes = resolveModelForTier('BUILD', tierMap, breaker);
  assert.ok(buildRes.candidate !== null);
  assert.equal(buildRes.candidate.id, 'gemini-3.8-flash');

  // Tier REASON: Lowest cost reasoning model (Terra at $4.375 < Sol at $8.75 < Astra at $26.25)
  const reasonRes = resolveModelForTier('REASON', tierMap, breaker);
  assert.ok(reasonRes.candidate !== null);
  assert.equal(reasonRes.candidate.id, 'gpt-5.6-terra');

  // Tier ARCHITECT: Upper reasoning model (Sol at $8.75)
  const archRes = resolveModelForTier('ARCHITECT', tierMap, breaker);
  assert.ok(archRes.candidate !== null);
  assert.equal(archRes.candidate.id, 'gpt-5.6-sol');

  // Tier ORACLE: Apex frontier model (Astra at $26.25)
  const oracleRes = resolveModelForTier('ORACLE', tierMap, breaker);
  assert.ok(oracleRes.candidate !== null);
  assert.equal(oracleRes.candidate.id, 'gpt-6-astra');
});

test('5. Dynamic Adaptation: Only 2 Models Available', () => {
  // User only has a small model and a large model
  const mockModels = [
    { provider: 'local', id: 'small-model', cost: { input: 0.1, output: 0.2 }, reasoning: false, contextWindow: 32000 },
    { provider: 'local', id: 'smart-model', cost: { input: 2.0, output: 4.0 }, reasoning: true, contextWindow: 64000 }
  ];

  const candidates = buildModelCandidates(mockModels);
  const tierMap = groupAndSortTiers(candidates);
  const breaker = new CircuitBreaker();

  // FAST & BUILD take the small model
  assert.equal(resolveModelForTier('FAST', tierMap, breaker).candidate.id, 'small-model');
  assert.equal(resolveModelForTier('BUILD', tierMap, breaker).candidate.id, 'small-model');

  // REASON & ORACLE take the smart model
  assert.equal(resolveModelForTier('REASON', tierMap, breaker).candidate.id, 'smart-model');
  assert.equal(resolveModelForTier('ORACLE', tierMap, breaker).candidate.id, 'smart-model');
});

test('6. Dynamic Adaptation: 100% Free / Local Models (Zero Cost)', () => {
  // Local Ollama models with cost: 0
  const mockModels = [
    { provider: 'ollama', id: 'qwen2.5-coder:7b', cost: { input: 0, output: 0 }, reasoning: false, contextWindow: 32000 },
    { provider: 'ollama', id: 'deepseek-r1:32b', cost: { input: 0, output: 0 }, reasoning: true, contextWindow: 64000 }
  ];

  const candidates = buildModelCandidates(mockModels);
  const tierMap = groupAndSortTiers(candidates);
  const breaker = new CircuitBreaker();

  // Standard workhorse takes non-reasoning qwen
  assert.equal(resolveModelForTier('BUILD', tierMap, breaker).candidate.id, 'qwen2.5-coder:7b');

  // Reasoning workhorse takes deepseek-r1
  assert.equal(resolveModelForTier('REASON', tierMap, breaker).candidate.id, 'deepseek-r1:32b');
  assert.equal(resolveModelForTier('ORACLE', tierMap, breaker).candidate.id, 'deepseek-r1:32b');
});

test('7. Context Window Promotion for Massive Prompts (>30k tokens)', () => {
  const mockModels = [
    { provider: 'openai-codex', id: 'standard-model', cost: { input: 0.10, output: 0.40 }, contextWindow: 128000 },
    { provider: 'antigravity', id: 'huge-context-model', cost: { input: 0.15, output: 0.60 }, contextWindow: 1048576 }
  ];
  const candidates = buildModelCandidates(mockModels);
  const tierMap = groupAndSortTiers(candidates);
  const breaker = new CircuitBreaker();

  // Normal task -> cheapest standard model
  const normalRes = resolveModelForTier('FAST', tierMap, breaker, 500);
  assert.equal(normalRes.candidate.id, 'standard-model');

  // Massive task (40,000 tokens) -> Promoted to huge context model
  const massiveRes = resolveModelForTier('FAST', tierMap, breaker, 40000);
  assert.equal(massiveRes.candidate.id, 'huge-context-model');
  assert.equal(massiveRes.ruleSource, 'context-promotion');
});

test('8. No Upward Escalation Fallback under Rate-Limits', () => {
  const mockModels = [
    { provider: 'openai-codex', id: 'terra', cost: { input: 2.5, output: 10 }, reasoning: true, contextWindow: 128000 },
    { provider: 'antigravity', id: 'flash', cost: { input: 0.1, output: 0.4 }, reasoning: false, contextWindow: 1048576 },
    { provider: 'openai-codex', id: 'sol', cost: { input: 5.0, output: 20 }, reasoning: true, contextWindow: 128000 }
  ];
  const candidates = buildModelCandidates(mockModels);
  const tierMap = groupAndSortTiers(candidates);
  const breaker = new CircuitBreaker();

  // Initially REASON picks terra
  const initial = resolveModelForTier('REASON', tierMap, breaker);
  assert.equal(initial.candidate.id, 'terra');

  // OpenAI fails with 429
  breaker.recordFailure('openai-codex');

  // Next REASON dispatch must NOT escalate to sol; it must pick flash from BUILD/downward
  const fallback = resolveModelForTier('REASON', tierMap, breaker);
  assert.equal(fallback.candidate.provider, 'antigravity');
  assert.equal(fallback.candidate.id, 'flash');
  assert.ok(fallback.cooldownAvoided.includes('openai-codex/terra'));
});
