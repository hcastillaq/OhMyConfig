/**
 * Gestor de Salud y Circuit Breaker de Proveedores en Memoria.
 *
 * Propósito e Invariantes:
 * 1. Aislamiento de Fallas Transitorias: Cuando un proveedor alcanza su límite de cuota
 *    (HTTP 429) o sufre sobrecarga (503), este componente lo aísla temporalmente en memoria
 *    para que los subagentes posteriores salten de inmediato al modelo de respaldo (fallback)
 *    sin acumular bloqueos o demoras repetitivas.
 * 2. Inmunidad a Falsos Positivos: Las tareas de desarrollo y revisión de código discuten
 *    frecuentemente términos como '429', 'rate limit' o métodos 'overloaded' en sus outputs
 *    exitosos. El detector de errores de cuota exige explícitamente que la ejecución del tool
 *    haya culminado con estado de fallo (isError === true) para evitar poner en enfriamiento
 *    proveedores saludables durante tareas legítimas de programación.
 * 3. Ciclo de Vida por Sesión: El estado se almacena exclusivamente en memoria y expira
 *    de forma natural (10 minutos por defecto) para permitir que los proveedores se recuperen
 *    sin riesgo de corrupción de archivos o bloqueos zombies entre distintas sesiones de Pi.
 */

export class CircuitBreaker {
  private cooldowns: Map<string, number> = new Map();
  private defaultCooldownMs: number = 10 * 60 * 1000; // 10 minutos de enfriamiento preventivo

  constructor(cooldownMs?: number) {
    if (cooldownMs) this.defaultCooldownMs = cooldownMs;
  }

  /**
   * Registra un fallo de infraestructura y programa la expiración del cooldown.
   */
  public recordFailure(target: string): void {
    const key = target.toLowerCase().trim();
    const expiresAt = Date.now() + this.defaultCooldownMs;
    this.cooldowns.set(key, expiresAt);
  }

  /**
   * Comprueba si un proveedor o modelo específico se encuentra bajo período de enfriamiento.
   * Si el tiempo de expiración ya transcurrió, limpia la entrada en memoria de manera perezosa (lazy).
   */
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

  /**
   * Retorna los segundos restantes antes de que el proveedor vuelva a ser elegible.
   */
  public getRemainingSeconds(target: string): number {
    const key = target.toLowerCase().trim();
    const expiresAt = this.cooldowns.get(key);
    if (!expiresAt) return 0;

    const remaining = expiresAt - Date.now();
    return remaining > 0 ? Math.ceil(remaining / 1000) : 0;
  }

  /**
   * Retorna una instantánea limpia de todos los proveedores en enfriamiento activo,
   * purgando entradas vencidas.
   */
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

  /**
   * Evalúa si un resultado fallido corresponde a un agotamiento real de cuota o rate limit.
   *
   * Invariante estricto: Si la ejecución fue exitosa (isError === false), retorna false
   * de inmediato para evitar falsos positivos cuando los subagentes procesan código, tests
   * o commits que hagan referencia a códigos de estado 429 o conceptos de rate limiting.
   */
  public detectQuotaError(text: string, isError?: boolean): boolean {
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
