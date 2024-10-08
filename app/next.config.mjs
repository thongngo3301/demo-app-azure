import { exec } from "child_process";

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: false,
  output: "standalone",
  generateBuildId: async () => {
    // You can, for example, get the latest git commit hash here
    const gitHash =
      process.env.CI_COMMIT_SHORT_SHA ||
      (await (() =>
        new Promise((res) =>
          exec("git rev-parse --short HEAD", (err, result) => {
            if (err || !result) res();
            res(result.replace("\n", ""));
          })
        ))()) ||
      "unknown";
    const buildId = [gitHash, Date.now()].join("-");
    console.log(`[Build ID ${buildId}]`);
    return buildId;
  },
  poweredByHeader: false,
  trailingSlash: true,
};

export default nextConfig;
