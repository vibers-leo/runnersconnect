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
      <body className="min-h-screen" style={{ backgroundColor: "var(--bg-main)", color: "var(--text-main)" }}>

        {/* 네비게이션 */}
        <header style={{ borderBottom: "1px solid var(--border)", backgroundColor: "rgba(247,246,243,0.92)" }}
          className="sticky top-0 z-50 backdrop-blur-md">
          <div className="max-w-7xl mx-auto px-6 flex items-center justify-between h-16">
            <a href="/" className="flex items-center gap-2 font-black text-lg tracking-tight">
              <span className="w-8 h-8 rounded-lg flex items-center justify-center text-white text-sm font-black"
                style={{ backgroundColor: "var(--accent)" }}>R</span>
              <span style={{ color: "var(--text-main)" }}>Runner&apos;s Connect</span>
            </a>
            <nav className="hidden md:flex items-center gap-8">
              {[
                { href: "/races", label: "대회" },
                { href: "/calendar", label: "캘린더" },
                { href: "/communities", label: "커뮤니티" },
              ].map((item) => (
                <a key={item.href} href={item.href} className="nav-link text-sm font-medium">
                  {item.label}
                </a>
              ))}
              <a href="/login"
                className="px-5 py-2 text-sm font-bold rounded-lg transition-all hover:opacity-90"
                style={{ backgroundColor: "var(--accent)", color: "#ffffff" }}>
                로그인
              </a>
            </nav>
            <button className="md:hidden" style={{ color: "var(--text-main)" }}>
              <iconify-icon icon="solar:hamburger-menu-bold" width="24"></iconify-icon>
            </button>
          </div>
        </header>

        <main>{children}</main>

        {/* 푸터 */}
        <footer style={{ borderTop: "1px solid var(--border)", backgroundColor: "var(--bg-surface)" }} className="py-16">
          <div className="max-w-7xl mx-auto px-6">
            <div className="flex flex-col md:flex-row justify-between gap-10 mb-12">
              <div>
                <div className="flex items-center gap-2 font-black text-lg mb-3">
                  <span className="w-7 h-7 rounded-md flex items-center justify-center text-white text-xs font-black"
                    style={{ backgroundColor: "var(--accent)" }}>R</span>
                  Runner&apos;s Connect
                </div>
                <p className="text-sm" style={{ color: "var(--text-secondary)" }}>
                  러닝 대회 운영 플랫폼<br />계발자들(Vibers)
                </p>
              </div>
              <div className="flex gap-16 text-sm" style={{ color: "var(--text-secondary)" }}>
                <div className="flex flex-col gap-3">
                  <span className="font-bold text-xs uppercase tracking-widest" style={{ color: "var(--text-tertiary)" }}>서비스</span>
                  <a href="/races" className="nav-link">대회 둘러보기</a>
                  <a href="/calendar" className="nav-link">대회 캘린더</a>
                  <a href="/communities" className="nav-link">러닝 커뮤니티</a>
                </div>
                <div className="flex flex-col gap-3">
                  <span className="font-bold text-xs uppercase tracking-widest" style={{ color: "var(--text-tertiary)" }}>주최자</span>
                  <a href="/signup" className="nav-link">대회 개설하기</a>
                  <a href="/login" className="nav-link">로그인</a>
                </div>
              </div>
            </div>
            <div className="pt-6 text-xs flex items-center justify-between flex-wrap gap-2"
              style={{ borderTop: "1px solid var(--border)", color: "var(--text-tertiary)" }}>
              <span>© {new Date().getFullYear()} Runner&apos;s Connect. All rights reserved.</span>
              <div className="flex gap-4">
                <a href="/privacy" className="nav-link">개인정보처리방침</a>
                <a href="/terms" className="nav-link">이용약관</a>
              </div>
            </div>
          </div>
        </footer>
      </body>
    </html>
  );
}
