import Link from 'next/link';
import Image from 'next/image';

const IMG = 'https://runnersconnect.vibers.co.kr';

export default function HomePage() {
  return (
    <div style={{ backgroundColor: 'var(--bg-main)' }}>

      {/* ─── HERO ─── */}
      <section className="relative h-[92vh] min-h-[600px] overflow-hidden">
        <Image
          src={`${IMG}/hero_runner.png`}
          alt="서울 마라톤 2024"
          fill
          className="object-cover object-top"
          priority
        />
        <div className="absolute inset-0"
          style={{ background: 'linear-gradient(to bottom, rgba(0,0,0,0.15) 0%, rgba(0,0,0,0.5) 60%, rgba(0,0,0,0.75) 100%)' }} />

        <div className="relative z-10 h-full flex flex-col justify-end pb-16 px-6 max-w-7xl mx-auto">
          <div className="max-w-2xl">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold mb-6"
              style={{ backgroundColor: 'var(--accent)', color: '#fff' }}>
              <iconify-icon icon="solar:running-bold" width="14"></iconify-icon>
              러닝 대회 운영 플랫폼 #1
            </div>
            <h1 className="text-5xl md:text-7xl font-black text-white leading-tight mb-6"
              style={{ fontFamily: 'Gmarket Sans, Paperlogy, sans-serif', letterSpacing: '-0.03em' }}>
              대회를 열고,<br />기록을 남기다
            </h1>
            <p className="text-lg text-white/75 mb-10 leading-relaxed">
              대회 개설부터 참가자 접수, 배번호 관리,<br />
              공식 기록 발급까지. 하나의 플랫폼으로.
            </p>
            <div className="flex flex-wrap gap-3">
              <a href="/signup"
                className="inline-flex items-center gap-2 px-8 py-4 rounded-xl font-black text-base transition-all hover:scale-105"
                style={{ backgroundColor: 'var(--accent)', color: '#fff', boxShadow: '0 4px 20px rgba(240,78,35,0.4)' }}>
                <iconify-icon icon="solar:flag-bold" width="18"></iconify-icon>
                무료로 대회 개설하기
              </a>
              <a href="/races"
                className="inline-flex items-center gap-2 px-8 py-4 rounded-xl font-bold text-base transition-all hover:scale-105"
                style={{ backgroundColor: 'rgba(255,255,255,0.15)', color: '#fff', backdropFilter: 'blur(8px)', border: '1px solid rgba(255,255,255,0.25)' }}>
                <iconify-icon icon="solar:magnifer-bold" width="18"></iconify-icon>
                대회 둘러보기
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* ─── STATS ─── */}
      <section style={{ backgroundColor: 'var(--bg-surface)', borderBottom: '1px solid var(--border)' }}>
        <div className="max-w-7xl mx-auto px-6 py-10">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            {[
              { value: '1,240+', label: '누적 참가자', icon: 'solar:users-group-rounded-bold' },
              { value: '48개', label: '개최 대회', icon: 'solar:flag-bold' },
              { value: '92%', label: '주최자 만족도', icon: 'solar:star-bold' },
              { value: '5%', label: '업계 최저 수수료', icon: 'solar:wallet-bold' },
            ].map((s, i) => (
              <div key={i} className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0"
                  style={{ backgroundColor: 'rgba(240,78,35,0.08)' }}>
                  <iconify-icon icon={s.icon} width="20" style={{ color: 'var(--accent)' }}></iconify-icon>
                </div>
                <div>
                  <div className="text-2xl font-black" style={{ fontFamily: 'Paperlogy, monospace', color: 'var(--text-main)' }}>
                    {s.value}
                  </div>
                  <div className="text-xs" style={{ color: 'var(--text-secondary)' }}>{s.label}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ─── FEATURE: 기록이 전부다 ─── */}
      <section className="max-w-7xl mx-auto px-6 py-24">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div>
            <div className="text-xs font-bold tracking-widest uppercase mb-4" style={{ color: 'var(--accent)' }}>
              OFFICIAL RECORD
            </div>
            <h2 className="text-4xl md:text-5xl font-black mb-6 leading-tight">
              참가자에게<br />진짜 기록을 선물하세요
            </h2>
            <p className="text-lg mb-8 leading-relaxed" style={{ color: 'var(--text-secondary)' }}>
              완주한 모든 러너가 공식 기록을 확인할 수 있습니다.
              배번호 또는 이름 검색으로 순 기록(NET TIME), 구간 기록, 순위를 즉시 발급합니다.
            </p>

            {/* 기록 카드 미리보기 */}
            <div className="rounded-2xl p-6 mb-8"
              style={{ backgroundColor: 'var(--bg-surface)', border: '1px solid var(--border)', boxShadow: '0 4px 24px rgba(0,0,0,0.06)' }}>
              <div className="text-xs font-bold tracking-widest uppercase mb-1" style={{ color: 'var(--accent)' }}>
                OFFICIAL RECORD
              </div>
              <div className="text-sm mb-4" style={{ color: 'var(--text-secondary)' }}>서울 마라톤 2024 · 2024. 04. 14.</div>
              <div className="flex items-baseline gap-3 mb-4">
                <span className="text-5xl font-black" style={{ fontFamily: 'Paperlogy, monospace', color: 'var(--accent)' }}>#42</span>
                <span className="text-2xl font-black">홍길동</span>
              </div>
              <div className="text-center py-5 rounded-xl mb-4"
                style={{ background: 'linear-gradient(135deg, rgba(240,78,35,0.06) 0%, rgba(240,78,35,0.02) 100%)', border: '1px solid rgba(240,78,35,0.15)' }}>
                <div className="text-xs font-bold tracking-widest uppercase mb-1" style={{ color: 'var(--text-tertiary)' }}>
                  NET TIME (순 기록)
                </div>
                <div className="text-5xl font-black" style={{ fontFamily: 'Paperlogy, monospace', color: 'var(--accent)' }}>
                  3:42:17
                </div>
              </div>
              <div className="grid grid-cols-3 gap-2 text-center">
                {[{ label: '종합 순위', val: '284위' }, { label: '성별 순위', val: '198위' }, { label: '연령대', val: '42위' }].map((r, i) => (
                  <div key={i} className="py-2 rounded-lg" style={{ backgroundColor: 'var(--bg-main)' }}>
                    <div className="text-xs mb-0.5" style={{ color: 'var(--text-tertiary)' }}>{r.label}</div>
                    <div className="font-black text-sm">{r.val}</div>
                  </div>
                ))}
              </div>
            </div>

            <Link href="/races"
              className="inline-flex items-center gap-2 px-6 py-3 rounded-xl font-bold transition-all hover:scale-105"
              style={{ backgroundColor: 'var(--accent)', color: '#fff' }}>
              <iconify-icon icon="solar:running-bold" width="18"></iconify-icon>
              내 기록 찾기
            </Link>
          </div>

          {/* 새벽 러너 이미지 */}
          <div className="relative h-[500px] rounded-3xl overflow-hidden">
            <Image
              src={`${IMG}/hero.png`}
              alt="새벽 그룹 런"
              fill
              className="object-cover"
            />
            <div className="absolute inset-0 rounded-3xl"
              style={{ background: 'linear-gradient(to top, rgba(0,0,0,0.4) 0%, transparent 60%)' }} />
            <div className="absolute bottom-6 left-6 text-white">
              <div className="text-xs font-bold opacity-70 mb-1">DUBAI MARATHON</div>
              <div className="text-sm font-bold">새벽 6시, 1,240명이 함께 달립니다</div>
            </div>
          </div>
        </div>
      </section>

      {/* ─── 풀스크린: 해안 마라톤 ─── */}
      <section className="relative h-[70vh] overflow-hidden">
        <Image
          src={`${IMG}/hero_ocean.png`}
          alt="해안 마라톤"
          fill
          className="object-cover object-center"
        />
        <div className="absolute inset-0"
          style={{ background: 'linear-gradient(to right, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0.2) 60%, transparent 100%)' }} />
        <div className="relative z-10 h-full flex items-center px-6">
          <div className="max-w-7xl mx-auto w-full">
            <div className="max-w-lg">
              <div className="text-xs font-bold tracking-widest uppercase mb-4 text-white/60">RACE MANAGEMENT</div>
              <h2 className="text-4xl md:text-5xl font-black text-white mb-6 leading-tight">
                당신의 대회를<br />더 크게 만드는<br />플랫폼
              </h2>
              <p className="text-white/75 mb-8 leading-relaxed">
                포스터 하나로 대회를 자동 등록하고,<br />
                접수부터 기록 발급까지 자동화합니다.
              </p>
              <a href="/signup"
                className="inline-flex items-center gap-2 px-7 py-4 rounded-xl font-black transition-all hover:scale-105"
                style={{ backgroundColor: 'var(--accent)', color: '#fff' }}>
                지금 시작하기
                <iconify-icon icon="solar:arrow-right-bold" width="18"></iconify-icon>
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* ─── 크루 / 커뮤니티 ─── */}
      <section className="max-w-7xl mx-auto px-6 py-24">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div className="relative h-[460px] rounded-3xl overflow-hidden order-2 md:order-1">
            <Image
              src={`${IMG}/crew.png`}
              alt="러닝 크루"
              fill
              className="object-cover object-top"
            />
          </div>
          <div className="order-1 md:order-2">
            <div className="text-xs font-bold tracking-widest uppercase mb-4" style={{ color: 'var(--accent)' }}>
              RUNNING COMMUNITY
            </div>
            <h2 className="text-4xl md:text-5xl font-black mb-6 leading-tight">
              러닝 크루와<br />함께 달리세요
            </h2>
            <p className="text-lg mb-10 leading-relaxed" style={{ color: 'var(--text-secondary)' }}>
              전국의 러닝 크루가 Runner&apos;s Connect에서 활동합니다.
              대회를 통해 새로운 러너들을 만나고, 크루의 공식 기록을 함께 쌓아가세요.
            </p>
            <div className="flex flex-col gap-4">
              {[
                { icon: 'solar:users-group-rounded-bold', title: '크루 대회 전용 접수', desc: '크루 단체 접수 및 배번호 일괄 배정' },
                { icon: 'solar:chart-bold', title: '크루 기록 랭킹', desc: '크루별 평균 기록 및 완주율 통계' },
                { icon: 'solar:medal-ribbons-star-bold', title: '완주 배지 시스템', desc: '대회 완주 시 디지털 배지 자동 발급' },
              ].map((f, i) => (
                <div key={i} className="flex items-start gap-4 p-4 rounded-xl"
                  style={{ backgroundColor: 'var(--bg-surface)', border: '1px solid var(--border)' }}>
                  <div className="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0"
                    style={{ backgroundColor: 'rgba(240,78,35,0.08)' }}>
                    <iconify-icon icon={f.icon} width="20" style={{ color: 'var(--accent)' }}></iconify-icon>
                  </div>
                  <div>
                    <div className="font-bold mb-0.5">{f.title}</div>
                    <div className="text-sm" style={{ color: 'var(--text-secondary)' }}>{f.desc}</div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* ─── 주최자 기능 + 야간 이미지 ─── */}
      <section style={{ backgroundColor: 'var(--bg-surface)', borderTop: '1px solid var(--border)', borderBottom: '1px solid var(--border)' }}
        className="py-24">
        <div className="max-w-7xl mx-auto px-6">
          <div className="grid md:grid-cols-2 gap-12 items-center">
            <div>
              <div className="text-xs font-bold tracking-widest uppercase mb-4" style={{ color: 'var(--accent)' }}>
                FOR ORGANIZERS
              </div>
              <h2 className="text-4xl md:text-5xl font-black mb-6 leading-tight">
                주최자를 위한<br />올인원 백오피스
              </h2>
              <p className="text-lg mb-10 leading-relaxed" style={{ color: 'var(--text-secondary)' }}>
                대회 포스터만 있으면 시작할 수 있습니다.
                AI가 포스터를 분석해 대회 정보를 자동 입력합니다.
              </p>
              <div className="grid grid-cols-2 gap-3 mb-10">
                {[
                  { icon: 'solar:document-add-bold', title: 'AI 포스터 분석', desc: '자동 대회 정보 입력' },
                  { icon: 'solar:ticket-bold', title: '배번호 관리', desc: '자동 배정 & 수동 조정' },
                  { icon: 'solar:chart-2-bold', title: '실시간 통계', desc: '접수 현황 대시보드' },
                  { icon: 'solar:wallet-money-bold', title: '투명한 정산', desc: '5% + 500원/명' },
                  { icon: 'solar:diploma-bold', title: '완주증명서', desc: 'PDF 자동 발급' },
                  { icon: 'solar:share-bold', title: '공유 페이지', desc: '대회 홈페이지 즉시 생성' },
                ].map((f, i) => (
                  <div key={i} className="p-4 rounded-xl"
                    style={{ backgroundColor: 'var(--bg-main)', border: '1px solid var(--border)' }}>
                    <iconify-icon icon={f.icon} width="22" style={{ color: 'var(--accent)', display: 'block', marginBottom: '8px' }}></iconify-icon>
                    <div className="font-bold text-sm mb-0.5">{f.title}</div>
                    <div className="text-xs" style={{ color: 'var(--text-secondary)' }}>{f.desc}</div>
                  </div>
                ))}
              </div>
              <a href="/signup"
                className="inline-flex items-center gap-2 px-7 py-4 rounded-xl font-black transition-all hover:scale-105"
                style={{ backgroundColor: 'var(--accent)', color: '#fff' }}>
                무료로 시작하기
                <iconify-icon icon="solar:arrow-right-bold" width="18"></iconify-icon>
              </a>
            </div>

            <div className="relative h-[520px] rounded-3xl overflow-hidden">
              <Image
                src={`${IMG}/hero_night.png`}
                alt="야간 러너"
                fill
                className="object-cover object-center"
              />
              <div className="absolute inset-0 rounded-3xl"
                style={{ background: 'linear-gradient(to top, rgba(0,0,0,0.6) 0%, transparent 70%)' }} />
              <div className="absolute bottom-6 left-6 right-6">
                <div className="rounded-xl p-4"
                  style={{ backgroundColor: 'rgba(0,0,0,0.55)', backdropFilter: 'blur(12px)', border: '1px solid rgba(255,255,255,0.1)' }}>
                  <div className="text-xs text-white/60 mb-1">LIVE 접수 현황</div>
                  <div className="flex items-center justify-between mb-3">
                    <span className="text-white font-black text-sm">서울 야간 마라톤 2024</span>
                    <span className="text-xs font-bold px-2 py-0.5 rounded-full"
                      style={{ backgroundColor: 'rgba(240,78,35,0.25)', color: '#f04e23' }}>D-12</span>
                  </div>
                  <div className="h-1.5 rounded-full overflow-hidden mb-1" style={{ backgroundColor: 'rgba(255,255,255,0.15)' }}>
                    <div className="h-full rounded-full" style={{ width: '73%', backgroundColor: 'var(--accent)' }} />
                  </div>
                  <div className="text-xs text-white/60">873 / 1,200명 (73%)</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ─── 요금제 ─── */}
      <section className="max-w-7xl mx-auto px-6 py-24">
        <div className="text-center mb-14">
          <div className="text-xs font-bold tracking-widest uppercase mb-4" style={{ color: 'var(--accent)' }}>PRICING</div>
          <h2 className="text-4xl md:text-5xl font-black mb-4">투명한 요금제</h2>
          <p style={{ color: 'var(--text-secondary)' }}>숨겨진 비용 없이, 실제 수익이 날 때만 수수료가 발생합니다.</p>
        </div>
        <div className="grid md:grid-cols-3 gap-6">
          {[
            {
              name: '기본', fee: '5%', per: '+ 500원/참가자', desc: '소규모 크루 대회',
              features: ['대회 페이지 생성', '참가자 접수 관리', '배번호 자동 배정', '공식 기록 발급', '이메일 알림'],
              cta: '무료로 시작', highlight: false,
            },
            {
              name: '프로', fee: '3%', per: '+ 300원/참가자', desc: '500명 이상 중규모 대회',
              features: ['기본 기능 전체', 'AI 포스터 분석', '완주증명서 PDF', '크루 단체 접수', '우선 고객 지원'],
              cta: '프로 시작하기', highlight: true,
            },
            {
              name: '엔터프라이즈', fee: '협의', per: '맞춤 계약', desc: '지자체 · 대형 기획사',
              features: ['프로 기능 전체', '전담 매니저', '현장 운영 지원', '화이트라벨 옵션', 'SLA 보장'],
              cta: '문의하기', highlight: false,
            },
          ].map((plan, i) => (
            <div key={i} className="rounded-2xl overflow-hidden transition-all hover:scale-[1.02]"
              style={{
                backgroundColor: plan.highlight ? 'var(--accent)' : 'var(--bg-surface)',
                border: plan.highlight ? 'none' : '1px solid var(--border)',
                boxShadow: plan.highlight ? '0 12px 40px rgba(240,78,35,0.25)' : '0 2px 12px rgba(0,0,0,0.04)',
              }}>
              <div className="p-8">
                <div className="text-xs font-bold tracking-widest uppercase mb-4"
                  style={{ color: plan.highlight ? 'rgba(255,255,255,0.7)' : 'var(--text-tertiary)' }}>{plan.name}</div>
                <div className="text-5xl font-black mb-1"
                  style={{ fontFamily: 'Paperlogy, monospace', color: plan.highlight ? '#fff' : 'var(--text-main)' }}>{plan.fee}</div>
                <div className="text-sm mb-2" style={{ color: plan.highlight ? 'rgba(255,255,255,0.7)' : 'var(--text-secondary)' }}>{plan.per}</div>
                <div className="text-sm mb-8" style={{ color: plan.highlight ? 'rgba(255,255,255,0.6)' : 'var(--text-tertiary)' }}>{plan.desc}</div>
                <div className="flex flex-col gap-3 mb-8">
                  {plan.features.map((f, j) => (
                    <div key={j} className="flex items-center gap-2 text-sm"
                      style={{ color: plan.highlight ? 'rgba(255,255,255,0.85)' : 'var(--text-secondary)' }}>
                      <iconify-icon icon="solar:check-circle-bold" width="16"
                        style={{ color: plan.highlight ? '#fff' : 'var(--accent)' }}></iconify-icon>
                      {f}
                    </div>
                  ))}
                </div>
                <a href="/signup"
                  className="block text-center py-3 rounded-xl font-bold text-sm transition-all hover:opacity-90"
                  style={{
                    backgroundColor: plan.highlight ? '#fff' : 'var(--accent)',
                    color: plan.highlight ? 'var(--accent)' : '#fff',
                  }}>{plan.cta}</a>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* ─── FAQ ─── */}
      <section style={{ backgroundColor: 'var(--bg-surface)', borderTop: '1px solid var(--border)' }} className="py-24">
        <div className="max-w-3xl mx-auto px-6">
          <div className="text-center mb-14">
            <div className="text-xs font-bold tracking-widest uppercase mb-4" style={{ color: 'var(--accent)' }}>FAQ</div>
            <h2 className="text-4xl font-black">자주 묻는 질문</h2>
          </div>
          <div className="flex flex-col gap-4">
            {[
              { q: '수수료는 언제 발생하나요?', a: '참가자가 실제로 결제를 완료할 때만 수수료가 부과됩니다. 대회 개설 자체는 무료입니다.' },
              { q: '기록은 언제 등록할 수 있나요?', a: '대회 완료 후 주최자가 CSV 파일로 기록을 업로드하면 즉시 참가자에게 공개됩니다.' },
              { q: '완주증명서는 어떻게 발급되나요?', a: '기록이 등록된 참가자는 대회 결과 페이지에서 PDF 완주증명서를 무료로 다운로드할 수 있습니다.' },
              { q: '포스터 AI 분석 기능은 정확한가요?', a: '대부분의 한국어 대회 포스터에서 날짜, 장소, 거리, 신청 기간을 90% 이상 정확도로 인식합니다.' },
              { q: '환불 처리는 어떻게 하나요?', a: '참가자의 환불 요청 시 주최자 대시보드에서 직접 처리할 수 있으며, 환불 규정은 대회 생성 시 설정합니다.' },
            ].map((item, i) => (
              <div key={i} className="rounded-xl p-6"
                style={{ border: '1px solid var(--border)', backgroundColor: 'var(--bg-main)' }}>
                <div className="flex items-start gap-3">
                  <span className="font-black mt-0.5 flex-shrink-0 text-sm" style={{ color: 'var(--accent)' }}>Q.</span>
                  <div>
                    <div className="font-bold mb-2">{item.q}</div>
                    <div className="text-sm leading-relaxed" style={{ color: 'var(--text-secondary)' }}>{item.a}</div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ─── 최종 CTA ─── */}
      <section className="relative py-32 overflow-hidden">
        <Image
          src={`${IMG}/hero_dawn.png`}
          alt="새벽 달리기"
          fill
          className="object-cover object-center"
        />
        <div className="absolute inset-0"
          style={{ background: 'linear-gradient(135deg, rgba(240,78,35,0.85) 0%, rgba(0,0,0,0.65) 100%)' }} />
        <div className="relative z-10 text-center px-6 max-w-3xl mx-auto">
          <h2 className="text-4xl md:text-6xl font-black text-white mb-6 leading-tight">
            지금, 달리기 시작하세요
          </h2>
          <p className="text-xl text-white/75 mb-12 leading-relaxed">
            대한민국 러닝 대회의 새로운 기준.<br />
            Runner&apos;s Connect와 함께합니다.
          </p>
          <div className="flex flex-wrap justify-center gap-4">
            <a href="/signup"
              className="inline-flex items-center gap-2 px-10 py-5 rounded-xl font-black text-lg transition-all hover:scale-105"
              style={{ backgroundColor: '#fff', color: 'var(--accent)' }}>
              <iconify-icon icon="solar:flag-bold" width="20"></iconify-icon>
              대회 개설하기
            </a>
            <a href="/races"
              className="inline-flex items-center gap-2 px-10 py-5 rounded-xl font-black text-lg transition-all hover:scale-105"
              style={{ backgroundColor: 'rgba(255,255,255,0.15)', color: '#fff', backdropFilter: 'blur(8px)', border: '1px solid rgba(255,255,255,0.3)' }}>
              <iconify-icon icon="solar:running-bold" width="20"></iconify-icon>
              대회 참가하기
            </a>
          </div>
        </div>
      </section>
    </div>
  );
}
