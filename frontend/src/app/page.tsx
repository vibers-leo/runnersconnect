import Link from "next/link";

const stats = [
  { value: "1,240+", label: "누적 참가자" },
  { value: "48회", label: "개최된 대회" },
  { value: "92%", label: "주최자 재이용률" },
  { value: "5%", label: "업계 최저 수수료" },
];

const steps = [
  {
    step: "01",
    icon: "solar:document-add-bold",
    title: "대회 정보 입력",
    desc: "대회명, 일정, 장소, 거리 종목, 참가비, 정원을 입력하면 접수 페이지가 자동 생성됩니다.",
  },
  {
    step: "02",
    icon: "solar:share-bold",
    title: "접수 링크 공유",
    desc: "생성된 링크를 SNS, 카카오톡, 러닝 커뮤니티에 공유하세요. 참가자가 바로 신청할 수 있습니다.",
  },
  {
    step: "03",
    icon: "solar:users-group-rounded-bold",
    title: "참가자 관리",
    desc: "실시간으로 신청 현황을 확인하고, 참가자에게 공지를 보내고, 명단을 관리하세요.",
  },
  {
    step: "04",
    icon: "solar:medal-ribbons-star-bold",
    title: "대회 당일 & 정산",
    desc: "기록을 업로드하면 순위가 자동 계산됩니다. 완주증명서 발급, 수익 정산까지 원스톱.",
  },
];

const features = [
  {
    icon: "solar:flag-bold",
    title: "접수 페이지 자동 생성",
    desc: "대회 정보를 입력하면 참가 신청 페이지가 즉시 만들어집니다. 별도 개발 비용 없음.",
  },
  {
    icon: "solar:chart-2-bold",
    title: "실시간 신청 현황",
    desc: "대시보드에서 참가자 신청 현황, 결제 완료 여부, 종목별 정원을 실시간으로 확인.",
  },
  {
    icon: "solar:running-bold",
    title: "기록 자동 순위 계산",
    desc: "CSV나 엑셀로 기록을 업로드하면 종목별, 성별, 연령대별 순위가 자동 계산됩니다.",
  },
  {
    icon: "solar:diploma-bold",
    title: "완주증명서 자동 발급",
    desc: "대회 종료 후 참가자가 직접 다운로드. PDF로 이름, 기록, 순위가 담긴 증명서 발급.",
  },
  {
    icon: "solar:wallet-money-bold",
    title: "투명한 수익 정산",
    desc: "참가비 수납부터 주최자 정산까지. 수수료 5%만 제하고 지정 계좌로 자동 입금.",
  },
  {
    icon: "solar:bell-bold",
    title: "참가자 공지 발송",
    desc: "대회 D-7, D-1 자동 리마인더. 긴급 공지도 참가자 전원에게 문자/앱 알림으로.",
  },
  {
    icon: "solar:map-point-bold",
    title: "코스 정보 제공",
    desc: "GPX 업로드로 코스 지도를 참가자에게 공유. 고도표, 급수대 위치까지 표시 가능.",
  },
  {
    icon: "solar:graph-new-bold",
    title: "대회 분석 리포트",
    desc: "참가자 지역 분포, 연령대, 재참가율, 수익 분석 리포트를 대회 종료 후 자동 제공.",
  },
];

const races = [
  {
    title: "2026 서울 봄 마라톤",
    date: "2026.04.20",
    location: "서울 한강공원 망원지구",
    distances: ["5K", "10K", "하프"],
    participants: 342,
    maxParticipants: 500,
    fee: "30,000원~",
    status: "접수 중",
    dday: "D-11",
    image: "https://picsum.photos/seed/seoul-marathon/600/300",
  },
  {
    title: "부산 해안 러닝 페스티벌",
    date: "2026.05.03",
    location: "부산 해운대 백사장",
    distances: ["5K", "10K", "풀마라톤"],
    participants: 189,
    maxParticipants: 300,
    fee: "40,000원~",
    status: "접수 중",
    dday: "D-24",
    image: "https://picsum.photos/seed/busan-run/600/300",
  },
  {
    title: "한라산 트레일 챌린지",
    date: "2026.05.18",
    location: "제주 한라산 성판악 코스",
    distances: ["21K 트레일"],
    participants: 128,
    maxParticipants: 150,
    fee: "65,000원",
    status: "마감 임박",
    dday: "D-39",
    image: "https://picsum.photos/seed/hallasan-trail/600/300",
  },
];

const plans = [
  {
    name: "기본",
    desc: "소규모 대회·동호회",
    fee: "5%",
    unit: "참가비의",
    perPerson: "+ 500원/인",
    features: [
      "접수 페이지 생성",
      "참가자 관리",
      "기록 업로드 & 순위 계산",
      "완주증명서 발급",
      "이메일 공지",
    ],
    cta: "무료로 시작",
    highlight: false,
  },
  {
    name: "프로",
    desc: "중대형 공식 대회",
    fee: "3%",
    unit: "참가비의",
    perPerson: "+ 300원/인",
    features: [
      "기본 플랜 전체 포함",
      "문자 공지 (SMS)",
      "코스 지도 & GPX 제공",
      "대회 분석 리포트",
      "전담 운영 매니저",
      "브랜드 커스터마이징",
    ],
    cta: "문의하기",
    highlight: true,
  },
  {
    name: "엔터프라이즈",
    desc: "지자체·기업 후원 대회",
    fee: "협의",
    unit: "",
    perPerson: "",
    features: [
      "프로 플랜 전체 포함",
      "전용 도메인 & 페이지",
      "현장 체크인 시스템",
      "실시간 추적 & 중계",
      "스폰서 노출 관리",
      "계약 기반 맞춤 운영",
    ],
    cta: "상담 신청",
    highlight: false,
  },
];

const faqs = [
  {
    q: "대회 개설에 초기 비용이 드나요?",
    a: "아니요. 대회 개설 자체는 무료입니다. 참가자가 신청하고 결제가 발생할 때부터 수수료가 차감됩니다.",
  },
  {
    q: "참가비는 언제 정산되나요?",
    a: "대회 종료 후 7영업일 이내에 주최자가 등록한 계좌로 자동 입금됩니다.",
  },
  {
    q: "참가자 수 제한이 있나요?",
    a: "없습니다. 소규모 동호회 대회(20명)부터 대형 마라톤(5,000명+)까지 모두 지원합니다.",
  },
  {
    q: "대회를 취소해야 할 경우 어떻게 되나요?",
    a: "주최자가 취소 처리 시 참가자에게 전액 환불됩니다. 결제 수수료는 플랫폼이 부담합니다.",
  },
  {
    q: "러닝 대회 운영 경험이 없어도 되나요?",
    a: "네. 체크리스트, 운영 가이드, 전담 매니저 지원으로 처음 여는 대회도 문제없이 진행할 수 있습니다.",
  },
];

export default function Home() {
  return (
    <>
      {/* ── 히어로 ── */}
      <section className="relative min-h-screen flex items-center overflow-hidden"
        style={{ backgroundColor: "var(--bg-main)" }}>
        <div className="absolute inset-0 pointer-events-none">
          <div className="absolute top-1/3 right-0 w-[700px] h-[700px] rounded-full opacity-[0.07]"
            style={{ background: "radial-gradient(circle, var(--accent) 0%, transparent 65%)" }} />
        </div>

        <div className="relative max-w-7xl mx-auto px-6 py-32 w-full grid md:grid-cols-2 gap-16 items-center">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold mb-8 tracking-widest uppercase"
              style={{ backgroundColor: "rgba(232,255,42,0.1)", color: "var(--accent)", border: "1px solid rgba(232,255,42,0.2)" }}>
              <iconify-icon icon="solar:lightning-bold" width="14"></iconify-icon>
              국내 유일 러닝 대회 개최 플랫폼
            </div>

            <h1 className="text-5xl md:text-6xl font-black leading-none tracking-tight mb-6 uppercase">
              러닝 대회,<br />
              <span style={{ color: "var(--accent)" }}>직접 여세요.</span>
            </h1>

            <p className="text-lg mb-10 leading-relaxed" style={{ color: "var(--text-secondary)" }}>
              아이디어만 있으면 됩니다.<br />
              접수 페이지부터 기록 관리, 정산, 완주증명서까지<br />
              Runner&apos;s Connect가 전부 처리합니다.
            </p>

            <div className="flex flex-col sm:flex-row gap-4">
              <Link href="/signup"
                className="inline-flex items-center justify-center gap-2 px-8 py-4 font-bold rounded-xl text-lg transition-all hover:scale-105 hover:shadow-2xl"
                style={{ backgroundColor: "var(--accent)", color: "#0a0a0a", boxShadow: "0 0 30px var(--accent-glow)" }}>
                <iconify-icon icon="solar:flag-bold" width="20"></iconify-icon>
                대회 개최 시작하기
              </Link>
              <Link href="/races"
                className="inline-flex items-center justify-center gap-2 px-8 py-4 font-bold rounded-xl text-lg transition-all hover:bg-white/5"
                style={{ border: "1px solid var(--border)", color: "var(--text-main)" }}>
                대회 둘러보기
                <iconify-icon icon="solar:arrow-right-bold" width="20"></iconify-icon>
              </Link>
            </div>
          </div>

          {/* 우측: 대회 카드 미리보기 */}
          <div className="relative hidden md:block">
            <div className="rounded-2xl overflow-hidden p-6"
              style={{ backgroundColor: "var(--bg-surface)", border: "1px solid var(--border)" }}>
              <div className="flex items-center justify-between mb-4">
                <span className="text-sm font-bold" style={{ color: "var(--accent)" }}>대회 대시보드</span>
                <span className="text-xs px-2 py-1 rounded-full" style={{ backgroundColor: "rgba(232,255,42,0.1)", color: "var(--accent)" }}>
                  실시간
                </span>
              </div>
              <div className="text-3xl font-black mb-1" style={{ fontFamily: "Paperlogy, monospace" }}>342 / 500</div>
              <div className="text-sm mb-4" style={{ color: "var(--text-secondary)" }}>2026 서울 봄 마라톤 · 참가자</div>
              <div className="h-2 rounded-full mb-6" style={{ backgroundColor: "rgba(255,255,255,0.08)" }}>
                <div className="h-full rounded-full" style={{ width: "68%", backgroundColor: "var(--accent)" }} />
              </div>
              {[
                { label: "5K", count: 124, total: 200 },
                { label: "10K", count: 143, total: 200 },
                { label: "하프", count: 75, total: 100 },
              ].map((item, i) => (
                <div key={i} className="flex items-center gap-3 mb-3">
                  <span className="text-xs w-10 font-bold" style={{ color: "var(--text-secondary)" }}>{item.label}</span>
                  <div className="flex-1 h-1.5 rounded-full" style={{ backgroundColor: "rgba(255,255,255,0.08)" }}>
                    <div className="h-full rounded-full" style={{ width: `${(item.count / item.total) * 100}%`, backgroundColor: "var(--accent)", opacity: 0.7 }} />
                  </div>
                  <span className="text-xs" style={{ color: "var(--text-tertiary)", fontFamily: "Paperlogy, monospace" }}>{item.count}</span>
                </div>
              ))}
              <div className="mt-5 pt-5 flex justify-between" style={{ borderTop: "1px solid var(--border)" }}>
                <div>
                  <div className="text-xs mb-1" style={{ color: "var(--text-tertiary)" }}>예상 수익</div>
                  <div className="font-black" style={{ fontFamily: "Paperlogy, monospace", color: "var(--accent)" }}>₩9,890,000</div>
                </div>
                <div>
                  <div className="text-xs mb-1" style={{ color: "var(--text-tertiary)" }}>대회까지</div>
                  <div className="font-black" style={{ fontFamily: "Paperlogy, monospace" }}>D-11</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ── 수치 ── */}
      <section style={{ backgroundColor: "var(--bg-surface)", borderTop: "1px solid var(--border)", borderBottom: "1px solid var(--border)" }}
        className="py-12">
        <div className="max-w-7xl mx-auto px-6 grid grid-cols-2 md:grid-cols-4 gap-8">
          {stats.map((stat, i) => (
            <div key={i} className="text-center">
              <div className="text-4xl md:text-5xl font-black mb-1"
                style={{ color: "var(--accent)", fontFamily: "Paperlogy, monospace" }}>
                {stat.value}
              </div>
              <div className="text-sm" style={{ color: "var(--text-secondary)" }}>{stat.label}</div>
            </div>
          ))}
        </div>
      </section>

      {/* ── 진행 중인 대회 ── */}
      <section className="py-24" style={{ backgroundColor: "var(--bg-main)" }}>
        <div className="max-w-7xl mx-auto px-6">
          <div className="flex items-end justify-between mb-12">
            <div>
              <div className="text-xs font-bold tracking-widest uppercase mb-3" style={{ color: "var(--accent)" }}>UPCOMING RACES</div>
              <h2 className="text-3xl md:text-4xl font-black uppercase">지금 접수 중인 대회</h2>
            </div>
            <Link href="/races" className="nav-link text-sm font-bold hidden md:flex items-center gap-1">
              전체 보기 <iconify-icon icon="solar:arrow-right-bold" width="16"></iconify-icon>
            </Link>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {races.map((race, i) => (
              <div key={i} className="group rounded-2xl overflow-hidden transition-all hover:scale-[1.02] cursor-pointer"
                style={{ backgroundColor: "var(--bg-surface)", border: "1px solid var(--border)" }}>
                <div className="relative h-44 overflow-hidden">
                  <img src={race.image} alt={race.title} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" />
                  <div className="absolute inset-0" style={{ background: "linear-gradient(to top, rgba(0,0,0,0.8) 0%, transparent 50%)" }} />
                  <div className="absolute top-3 left-3 flex gap-2">
                    <span className="text-xs font-bold px-2.5 py-1 rounded-full"
                      style={{
                        backgroundColor: race.status === "마감 임박" ? "rgba(232,255,42,0.9)" : "rgba(0,0,0,0.7)",
                        color: race.status === "마감 임박" ? "#0a0a0a" : "var(--text-main)",
                        border: `1px solid ${race.status === "마감 임박" ? "transparent" : "var(--border)"}`,
                      }}>
                      {race.status}
                    </span>
                  </div>
                  <div className="absolute top-3 right-3 text-xs font-black px-2 py-1 rounded"
                    style={{ backgroundColor: "rgba(0,0,0,0.7)", fontFamily: "Paperlogy, monospace", color: "var(--accent)" }}>
                    {race.dday}
                  </div>
                </div>

                <div className="p-5">
                  <h3 className="text-lg font-bold mb-3">{race.title}</h3>
                  <div className="flex flex-col gap-1.5 mb-4">
                    <div className="flex items-center gap-2 text-sm" style={{ color: "var(--text-secondary)" }}>
                      <iconify-icon icon="solar:calendar-bold" width="14"></iconify-icon>
                      {race.date}
                    </div>
                    <div className="flex items-center gap-2 text-sm" style={{ color: "var(--text-secondary)" }}>
                      <iconify-icon icon="solar:map-point-bold" width="14"></iconify-icon>
                      {race.location}
                    </div>
                  </div>
                  <div className="flex gap-2 mb-4 flex-wrap">
                    {race.distances.map((d, j) => (
                      <span key={j} className="text-xs px-2 py-0.5 rounded-full font-bold"
                        style={{ backgroundColor: "rgba(255,255,255,0.06)", border: "1px solid var(--border)" }}>
                        {d}
                      </span>
                    ))}
                  </div>
                  <div className="flex items-center justify-between">
                    <div>
                      <div className="text-xs mb-1" style={{ color: "var(--text-tertiary)" }}>참가비</div>
                      <div className="font-black text-sm" style={{ fontFamily: "Paperlogy, monospace" }}>{race.fee}</div>
                    </div>
                    <div className="text-right">
                      <div className="text-xs mb-1" style={{ color: "var(--text-tertiary)" }}>{race.participants}/{race.maxParticipants}명</div>
                      <div className="w-24 h-1.5 rounded-full" style={{ backgroundColor: "rgba(255,255,255,0.08)" }}>
                        <div className="h-full rounded-full" style={{ width: `${(race.participants / race.maxParticipants) * 100}%`, backgroundColor: "var(--accent)" }} />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── 대회 여는 방법 ── */}
      <section className="py-24" style={{ backgroundColor: "var(--bg-surface)", borderTop: "1px solid var(--border)" }}>
        <div className="max-w-7xl mx-auto px-6">
          <div className="text-center mb-16">
            <div className="text-xs font-bold tracking-widest uppercase mb-3" style={{ color: "var(--accent)" }}>HOW IT WORKS</div>
            <h2 className="text-3xl md:text-4xl font-black uppercase mb-4">대회 개최, 이렇게 쉽습니다</h2>
            <p style={{ color: "var(--text-secondary)" }}>4단계로 나만의 러닝 대회를 열어보세요.</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {steps.map((step, i) => (
              <div key={i} className="relative p-6 rounded-2xl"
                style={{ backgroundColor: "var(--bg-main)", border: "1px solid var(--border)" }}>
                {i < steps.length - 1 && (
                  <div className="hidden lg:block absolute top-10 -right-3 z-10"
                    style={{ color: "var(--text-tertiary)" }}>
                    <iconify-icon icon="solar:arrow-right-bold" width="20"></iconify-icon>
                  </div>
                )}
                <div className="text-5xl font-black mb-4" style={{ color: "rgba(232,255,42,0.15)", fontFamily: "Paperlogy, monospace" }}>
                  {step.step}
                </div>
                <div className="w-10 h-10 rounded-xl flex items-center justify-center mb-4"
                  style={{ backgroundColor: "rgba(232,255,42,0.1)" }}>
                  <iconify-icon icon={step.icon} width="20" style={{ color: "var(--accent)" }}></iconify-icon>
                </div>
                <h3 className="font-bold mb-2">{step.title}</h3>
                <p className="text-sm leading-relaxed" style={{ color: "var(--text-secondary)" }}>{step.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── 기능 ── */}
      <section className="py-24" style={{ backgroundColor: "var(--bg-main)" }}>
        <div className="max-w-7xl mx-auto px-6">
          <div className="text-center mb-16">
            <div className="text-xs font-bold tracking-widest uppercase mb-3" style={{ color: "var(--accent)" }}>FEATURES</div>
            <h2 className="text-3xl md:text-4xl font-black uppercase mb-4">대회 운영에 필요한 모든 것</h2>
            <p style={{ color: "var(--text-secondary)" }}>복잡한 운영은 플랫폼이, 주최자는 러닝에만 집중하세요.</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
            {features.map((feature, i) => (
              <div key={i} className="p-5 rounded-2xl transition-all hover:scale-[1.02]"
                style={{ backgroundColor: "var(--bg-surface)", border: "1px solid var(--border)" }}>
                <div className="w-10 h-10 rounded-xl flex items-center justify-center mb-3"
                  style={{ backgroundColor: "rgba(232,255,42,0.1)" }}>
                  <iconify-icon icon={feature.icon} width="20" style={{ color: "var(--accent)" }}></iconify-icon>
                </div>
                <h3 className="font-bold mb-1.5 text-sm">{feature.title}</h3>
                <p className="text-xs leading-relaxed" style={{ color: "var(--text-secondary)" }}>{feature.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── 요금제 ── */}
      <section className="py-24" style={{ backgroundColor: "var(--bg-surface)", borderTop: "1px solid var(--border)" }}>
        <div className="max-w-5xl mx-auto px-6">
          <div className="text-center mb-16">
            <div className="text-xs font-bold tracking-widest uppercase mb-3" style={{ color: "var(--accent)" }}>PRICING</div>
            <h2 className="text-3xl md:text-4xl font-black uppercase mb-4">투명한 요금제</h2>
            <p style={{ color: "var(--text-secondary)" }}>숨겨진 비용 없음. 참가자가 생길 때만 비용이 발생합니다.</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {plans.map((plan, i) => (
              <div key={i} className="rounded-2xl p-7 flex flex-col"
                style={{
                  backgroundColor: plan.highlight ? "var(--accent)" : "var(--bg-main)",
                  border: `1px solid ${plan.highlight ? "transparent" : "var(--border)"}`,
                  color: plan.highlight ? "#0a0a0a" : "var(--text-main)",
                }}>
                <div className="mb-6">
                  <div className="text-xs font-bold tracking-widest uppercase mb-1"
                    style={{ color: plan.highlight ? "rgba(0,0,0,0.5)" : "var(--text-secondary)" }}>
                    {plan.name}
                  </div>
                  <div className="font-bold text-sm mb-4"
                    style={{ color: plan.highlight ? "rgba(0,0,0,0.6)" : "var(--text-secondary)" }}>
                    {plan.desc}
                  </div>
                  <div>
                    <span className="text-xs" style={{ color: plan.highlight ? "rgba(0,0,0,0.5)" : "var(--text-tertiary)" }}>
                      {plan.unit}
                    </span>
                    <span className="text-4xl font-black mx-1" style={{ fontFamily: "Paperlogy, monospace" }}>
                      {plan.fee}
                    </span>
                  </div>
                  {plan.perPerson && (
                    <div className="text-sm mt-1" style={{ color: plan.highlight ? "rgba(0,0,0,0.5)" : "var(--text-secondary)" }}>
                      {plan.perPerson}
                    </div>
                  )}
                </div>

                <ul className="flex-1 flex flex-col gap-2.5 mb-8">
                  {plan.features.map((f, j) => (
                    <li key={j} className="flex items-start gap-2 text-sm">
                      <iconify-icon icon="solar:check-circle-bold" width="16"
                        style={{ color: plan.highlight ? "#0a0a0a" : "var(--accent)", flexShrink: 0, marginTop: "2px" }}>
                      </iconify-icon>
                      <span style={{ color: plan.highlight ? "#0a0a0a" : "var(--text-secondary)" }}>{f}</span>
                    </li>
                  ))}
                </ul>

                <Link href={plan.name === "기본" ? "/signup" : "/contact"}
                  className="block text-center py-3 rounded-xl font-bold text-sm transition-all hover:scale-105"
                  style={{
                    backgroundColor: plan.highlight ? "#0a0a0a" : "var(--accent)",
                    color: plan.highlight ? "var(--accent)" : "#0a0a0a",
                  }}>
                  {plan.cta}
                </Link>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── FAQ ── */}
      <section className="py-24" style={{ backgroundColor: "var(--bg-main)" }}>
        <div className="max-w-3xl mx-auto px-6">
          <div className="text-center mb-16">
            <div className="text-xs font-bold tracking-widest uppercase mb-3" style={{ color: "var(--accent)" }}>FAQ</div>
            <h2 className="text-3xl font-black uppercase">자주 묻는 질문</h2>
          </div>

          <div className="flex flex-col gap-4">
            {faqs.map((faq, i) => (
              <div key={i} className="p-6 rounded-2xl"
                style={{ backgroundColor: "var(--bg-surface)", border: "1px solid var(--border)" }}>
                <div className="flex items-start gap-3">
                  <span className="text-sm font-black mt-0.5" style={{ color: "var(--accent)", fontFamily: "Paperlogy, monospace" }}>Q</span>
                  <div>
                    <div className="font-bold mb-2">{faq.q}</div>
                    <div className="text-sm leading-relaxed" style={{ color: "var(--text-secondary)" }}>{faq.a}</div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── 최종 CTA ── */}
      <section className="py-32 relative overflow-hidden" style={{ backgroundColor: "var(--bg-surface)", borderTop: "1px solid var(--border)" }}>
        <div className="absolute inset-0 pointer-events-none">
          <div className="absolute inset-0 flex items-center justify-center opacity-5">
            <iconify-icon icon="solar:running-bold" width="600" style={{ color: "var(--accent)" }}></iconify-icon>
          </div>
        </div>
        <div className="relative max-w-3xl mx-auto px-6 text-center">
          <div className="text-xs font-bold tracking-widest uppercase mb-4" style={{ color: "var(--accent)" }}>GET STARTED</div>
          <h2 className="text-4xl md:text-5xl font-black uppercase mb-6">
            당신의 대회를<br />
            <span style={{ color: "var(--accent)" }}>지금 시작하세요</span>
          </h2>
          <p className="text-lg mb-10" style={{ color: "var(--text-secondary)" }}>
            첫 대회 개설은 무료. 참가자가 결제할 때만 수수료가 발생합니다.<br />
            지금 바로 대회 페이지를 만들어보세요.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link href="/signup"
              className="inline-flex items-center justify-center gap-2 px-10 py-5 font-black rounded-xl text-xl transition-all hover:scale-105"
              style={{ backgroundColor: "var(--accent)", color: "#0a0a0a", boxShadow: "0 0 40px var(--accent-glow)" }}>
              <iconify-icon icon="solar:lightning-bold" width="24"></iconify-icon>
              무료로 대회 개설하기
            </Link>
            <Link href="/races"
              className="inline-flex items-center justify-center gap-2 px-10 py-5 font-bold rounded-xl text-xl transition-all hover:bg-white/5"
              style={{ border: "1px solid var(--border)", color: "var(--text-main)" }}>
              대회 둘러보기
            </Link>
          </div>
        </div>
      </section>
    </>
  );
}
