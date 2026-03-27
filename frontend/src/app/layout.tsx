import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Runner's Connect - 러닝 대회 운영 플랫폼",
  description: "러닝 대회 접수부터 기록 관리, 정산까지. 주최자를 위한 올인원 대회 운영 플랫폼.",
  openGraph: {
    title: "Runner's Connect",
    description: "러닝 대회 접수부터 기록 관리, 정산까지",
    siteName: "Runner's Connect",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="ko">
      <body className="bg-gray-50 min-h-screen">
        <header className="bg-white border-b border-gray-200 sticky top-0 z-50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex items-center justify-between h-16">
              <a href="/" className="text-xl font-bold text-indigo-600">
                Runner&apos;s Connect
              </a>
              <nav className="hidden md:flex items-center gap-6">
                <a href="/races" className="text-sm font-medium text-gray-700 hover:text-indigo-600">
                  대회
                </a>
                <a href="/calendar" className="text-sm font-medium text-gray-700 hover:text-indigo-600">
                  캘린더
                </a>
                <a href="/communities" className="text-sm font-medium text-gray-700 hover:text-indigo-600">
                  커뮤니티
                </a>
                <a href="/login" className="px-4 py-2 bg-indigo-600 text-white text-sm font-bold rounded-lg hover:bg-indigo-700 transition">
                  로그인
                </a>
              </nav>
            </div>
          </div>
        </header>
        <main>{children}</main>
      </body>
    </html>
  );
}
