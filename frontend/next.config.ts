import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'runnersconnect.vibers.co.kr',
      },
    ],
  },
  // Rails API 프록시
  async rewrites() {
    return [
      {
        source: "/api/:path*",
        destination: `${process.env.NEXT_PUBLIC_API_URL || "http://localhost:4070"}/api/:path*`,
      },
    ];
  },
};

export default nextConfig;
