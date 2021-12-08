export function getEnv(key: string): string {
  if (!process.env[key]) throw Error("Environment variable not found");
  return process.env[key] as string;
}

export function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
