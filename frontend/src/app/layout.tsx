import type { Metadata } from "next";
import "./globals.css";
import Script from "next/script";

export const metadata: Metadata = {
  title: "Runner's Connect — 러닝 대회 운영 플랫폼",
  description: "대회 개설부터 접수, 기록 관리, 정산까지. 주최자를 위한 올인원 러닝 대회 플랫폼.",
  openGraph: {
    title: "Runner's Connect",
    description: "대회 개설부터 접수, 기록 관리, 정산까지",
    siteName: "Runner's Connect",
    type: "website",
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ko">
      <head>
        <Script src="https://code.iconify.design/iconify-icon/2.3.0/iconify-icon.min.js" strategy="beforeInteractive" />
      </head>
      <body className="grain min-h-screen" style={{ backgroundColor: "var(--bg-main)", color: "var(--text-main)" }}>
        {/* 그레인 텍스처 */}
        <style>{`
          .grain::before {
            content: '';
            position: fixed; inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.04'/%3E%3C/svg%3E");
            pointer-events: none; z-index: 999; opacity: 0.35;
          }
        `}</style>

        {/* 네비게이션 */}
        <header style={{ borderBottom: "1px solid var(--border)", backgroundColor: "rgba(10,10,10,0.92)" }}
          className="sticky top-0 z-50 backdrop-blur-md">
          <div className="max-w-7xl mx-auto px-6 flex items-center justify-between h-16">
            <a href="/" className="flex items-center gap-2 font-bold text-lg tracking-tight">
              <span style={{ color: "var(--accent)" }}>R</span>
              <span style={{ color: "var(--text-main)" }}>Runner&apos;s Connect</span>
            </a>
            <nav className="hidden md:flex items-center gap-8">
              {[
                { href: "/races", label: "대회" },
                { href: "/calendar", label: "캘린더" },
                { href: "/communities", label: "커뮤니티" },
              ].map((item) => (
                <a key={item.href} href={item.href} className="nav-link text-sm font-medium transition-colors">
                  {item.label}
                </a>
              ))}
              <a href="/login"
                className="px-5 py-2 text-sm font-bold rounded-lg transition-all"
                style={{ backgroundColor: "var(--accent)", color: "#0a0a0a" }}
              >
                로그인
              </a>
            </nav>
            {/* 모바일 햄버거 */}
            <button className="md:hidden" style={{ color: "var(--text-main)" }}>
              <iconify-icon icon="solar:hamburger-menu-bold" width="24"></iconify-icon>
            </button>
          </div>
        </header>

        <main>{children}</main>

        {/* 푸터 */}
        <footer style={{ borderTop: "1px solid var(--border)", backgroundColor: "var(--bg-surface)" }} className="py-12">
          <div className="max-w-7xl mx-auto px-6">
            <div className="flex flex-col md:flex-row justify-between gap-8">
              <div>
                <div className="font-bold text-lg mb-2">
                  <span style={{ color: "var(--accent)" }}>R</span> Runner&apos;s Connect
                </div>
                <p className="text-sm" style={{ color: "var(--text-secondary)" }}>
                  러닝 대회 운영 플랫폼 · 계발자들(Vibers)
                </p>
              </div>
              <div className="flex gap-12 text-sm" style={{ color: "var(--text-secondary)" }}>
                <div className="flex flex-col gap-2">
                  <span className="font-bold" style={{ color: "var(--text-main)" }}>서비스</span>
                  <a href="/races" className="hover:text-white transition-colors">대회 둘러보기</a>
                  <a href="/calendar" className="hover:text-white transition-colors">대회 캘린더</a>
                  <a href="/communities" className="hover:text-white transition-colors">러닝 커뮤니티</a>
                </div>
                <div className="flex flex-col gap-2">
                  <span className="font-bold" style={{ color: "var(--text-main)" }}>주최자</span>
                  <a href="/signup" className="hover:text-white transition-colors">대회 개설하기</a>
                  <a href="/login" className="hover:text-white transition-colors">로그인</a>
                </div>
              </div>
            </div>
            <div className="mt-10 pt-6 text-xs" style={{ borderTop: "1px solid var(--border)", color: "var(--text-tertiary)" }}>
              © {new Date().getFullYear()} Runner&apos;s Connect. All rights reserved.
            </div>
          </div>
        </footer>
      </body>
    </html>
  );
}
