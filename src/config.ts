import { config as loadEnv } from "dotenv";

loadEnv();

export interface FirecrawlRuntimeConfig {
  apiKey: string;
  apiUrl: string;
  defaultTimeoutMs: number;
  maxRetries: number;
  cacheTtlMs: number;
  cacheMaxEntries: number;
}

const NUMBER_PATTERN = /^-?\d+(\.\d+)?$/;

const resolvedConfig: FirecrawlRuntimeConfig = (() => {
  const primaryKey = process.env.FIRECRAWL_API_KEY;
  const backupKeys = [
    process.env.FIRECRAWL_API_KEY_BACKUP_1,
    process.env.FIRECRAWL_API_KEY_BACKUP_2,
    process.env.FIRECRAWL_API_KEY_BACKUP_3,
  ].filter(Boolean) as string[];

  const apiKey = primaryKey ?? backupKeys[0];

  if (!apiKey) {
    throw new Error(
      "Missing Firecrawl API key. Set FIRECRAWL_API_KEY or one of the backup variables.",
    );
  }

  const apiUrl = process.env.FIRECRAWL_API_URL?.trim() || "https://api.firecrawl.dev";

  const defaultTimeoutSeconds = pickNumberEnv("FIRECRAWL_TIMEOUT");
  const cacheTtlMsOverride = pickNumberEnv("FIRECRAWL_CACHE_TTL_MS");
  const cacheTtlSeconds =
    pickNumberEnv("FIRECRAWL_CACHE_TTL_SECONDS") ?? pickNumberEnv("FIRECRAWL_CACHE_TTL");
  const cacheMaxEntries = pickNumberEnv("FIRECRAWL_CACHE_MAX_ENTRIES");
  const maxRetries = pickNumberEnv("FIRECRAWL_MAX_RETRIES");

  return {
    apiKey,
    apiUrl,
    defaultTimeoutMs: 1000 * (defaultTimeoutSeconds ?? 60),
    maxRetries: maxRetries ?? 3,
    cacheTtlMs:
      cacheTtlMsOverride ??
      (cacheTtlSeconds !== undefined ? cacheTtlSeconds * 1000 : 10 * 60 * 1000),
    cacheMaxEntries: cacheMaxEntries ?? 128,
  };
})();

export function getFirecrawlConfig(): FirecrawlRuntimeConfig {
  return resolvedConfig;
}

function pickNumberEnv(name: string): number | undefined {
  const raw = process.env[name];

  if (!raw) {
    return undefined;
  }

  const trimmed = raw.trim();

  if (!NUMBER_PATTERN.test(trimmed)) {
    return undefined;
  }

  const asNumber = Number(trimmed);

  return Number.isNaN(asNumber) ? undefined : asNumber;
}
