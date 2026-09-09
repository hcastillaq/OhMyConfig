export class CircuitBreaker {
  private cooldowns: Map<string, number> = new Map();
  private defaultCooldownMs: number = 10 * 60 * 1000; // 10 minutes

  constructor(cooldownMs?: number) {
    if (cooldownMs) this.defaultCooldownMs = cooldownMs;
  }

  public recordFailure(target: string): void {
    const key = target.toLowerCase().trim();
    const expiresAt = Date.now() + this.defaultCooldownMs;
    this.cooldowns.set(key, expiresAt);
  }

  public isCoolingDown(target: string): boolean {
    const key = target.toLowerCase().trim();
    const expiresAt = this.cooldowns.get(key);
    if (!expiresAt) return false;

    if (Date.now() > expiresAt) {
      this.cooldowns.delete(key);
      return false;
    }
    return true;
  }

  public getRemainingSeconds(target: string): number {
    const key = target.toLowerCase().trim();
    const expiresAt = this.cooldowns.get(key);
    if (!expiresAt) return 0;

    const remaining = expiresAt - Date.now();
    return remaining > 0 ? Math.ceil(remaining / 1000) : 0;
  }

  public getActiveCooldowns(): Array<{ target: string; remainingSec: number }> {
    const active: Array<{ target: string; remainingSec: number }> = [];
    const now = Date.now();

    for (const [key, expiresAt] of this.cooldowns.entries()) {
      if (now < expiresAt) {
        active.push({ target: key, remainingSec: Math.ceil((expiresAt - now) / 1000) });
      } else {
        this.cooldowns.delete(key);
      }
    }
    return active;
  }

  public detectQuotaError(text: string, isError?: boolean): boolean {
    // Only flag quota errors when the execution actually failed
    if (isError === false) return false;
    if (!text || typeof text !== 'string') return false;

    const lower = text.toLowerCase();
    const hasQuotaPattern =
      /\b429\b/.test(lower) ||
      lower.includes('too many requests') ||
      lower.includes('rate limit') ||
      lower.includes('ratelimit') ||
      lower.includes('quota exceeded') ||
      lower.includes('insufficient_quota') ||
      lower.includes('resource exhausted') ||
      lower.includes('model_overloaded') ||
      lower.includes('503 service unavailable');

    return hasQuotaPattern;
  }
}
