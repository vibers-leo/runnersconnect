import Link from "next/link";

export default function Home() {
  return (
    <div>
      {/* Hero */}
      <section className="bg-gradient-to-br from-indigo-600 via-indigo-700 to-purple-800 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 md:py-28">
          <div className="text-center max-w-3xl mx-auto">
            <h1 className="text-4xl md:text-5xl lg:text-6xl font-black leading-tight mb-6">
              러닝 대회,<br />
              <span className="text-indigo-200">더 쉽게 운영하세요</span>
            </h1>
            <p className="text-lg md:text-xl text-indigo-100 mb-10 leading-relaxed">
              접수부터 기록 관리, 정산까지.<br />
              주최자를 위한 올인원 대회 운영 플랫폼.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link
                href="/races"
                className="px-8 py-4 bg-white text-indigo-700 font-bold rounded-xl hover:bg-gray-100 transition shadow-lg text-lg"
              >
                대회 둘러보기
              </Link>
              <Link
                href="/signup"
                className="px-8 py-4 border-2 border-white text-white font-bold rounded-xl hover:bg-white/10 transition text-lg"
              >
                주최자 등록
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* 특징 */}
      <section className="py-16 md:py-24 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-black text-gray-900 text-center mb-12">
            왜 Runner&apos;s Connect인가요?
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              {
                icon: "📋",
                title: "원클릭 대회 개설",
                desc: "복잡한 대회 운영, 클릭 몇 번으로 끝. 접수 페이지가 자동 생성됩니다.",
              },
              {
                icon: "🏃",
                title: "실시간 기록 관리",
                desc: "CSV 업로드로 수천 명의 기록을 한 번에. 순위도 자동 계산.",
              },
              {
                icon: "💰",
                title: "투명한 정산",
                desc: "수수료 5% + 참가자당 500원. 정산 내역을 실시간으로 확인하세요.",
              },
            ].map((feature, i) => (
              <div
                key={i}
                className="text-center p-8 rounded-2xl border border-gray-100 hover:shadow-lg transition"
              >
                <div className="text-4xl mb-4">{feature.icon}</div>
                <h3 className="text-xl font-bold text-gray-900 mb-2">{feature.title}</h3>
                <p className="text-gray-600">{feature.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-3xl mx-auto px-4 text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            지금 바로 시작하세요
          </h2>
          <p className="text-gray-600 mb-8">
            첫 대회 개설은 무료. 참가자가 생기면 그때부터 수수료가 발생합니다.
          </p>
          <Link
            href="/signup"
            className="inline-block px-8 py-4 bg-indigo-600 text-white font-bold rounded-xl hover:bg-indigo-700 transition text-lg"
          >
            무료로 시작하기
          </Link>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-gray-400 py-10">
        <div className="max-w-7xl mx-auto px-4 text-center text-sm">
          <p className="font-semibold text-white mb-1">Runner&apos;s Connect</p>
          <p>러닝 대회 운영 플랫폼 · 계발자들(Vibers)</p>
          <p className="mt-4">© {new Date().getFullYear()} Runner&apos;s Connect. All rights reserved.</p>
        </div>
      </footer>
    </div>
  );
}
