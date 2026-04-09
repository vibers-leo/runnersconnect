import Link from 'next/link';

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'https://runnersconnect.vibers.co.kr';

interface RaceEdition {
  id: number;
  name: string;
  start_at: string;
  end_at: string;
  max_participants: number;
  registered_count: number;
}

interface Race {
  id: number;
  title: string;
  description: string;
  location: string;
  status: string;
  registration_start: string;
  registration_end: string;
  race_editions: RaceEdition[];
}

async function getRace(id: string): Promise<Race | null> {
  try {
    const res = await fetch(`${API_BASE}/api/v1/races/${id}`, { cache: 'no-store' });
    if (!res.ok) return null;
    const data = await res.json();
    return data.data?.attributes ? { id: data.data.id, ...data.data.attributes } : data;
  } catch {
    return null;
  }
}

export default async function RacePage({ params }: { params: { id: string } }) {
  const race = await getRace(params.id);

  if (!race) {
    return (
      <div className="min-h-screen flex items-center justify-center" style={{ backgroundColor: 'var(--bg-main)' }}>
        <div className="text-center">
          <div className="text-6xl mb-4" style={{ color: 'var(--text-tertiary)' }}>404</div>
          <p style={{ color: 'var(--text-secondary)' }}>대회를 찾을 수 없습니다.</p>
          <Link href="/races" className="nav-link mt-4 inline-block">← 대회 목록으로</Link>
        </div>
      </div>
    );
  }

  const edition = race.race_editions?.[0];
  const progressPct = edition
    ? Math.min(100, Math.round((edition.registered_count / edition.max_participants) * 100))
    : 0;

  return (
    <div className="min-h-screen" style={{ backgroundColor: 'var(--bg-main)' }}>
      <div className="max-w-3xl mx-auto px-6 py-16">

        {/* 뒤로가기 */}
        <Link href="/races" className="nav-link inline-flex items-center gap-1 text-sm mb-10">
          <iconify-icon icon="solar:arrow-left-bold" width="16"></iconify-icon>
          대회 목록
        </Link>

        {/* 헤더 */}
        <div className="mb-10">
          <div className="text-xs font-bold tracking-widest uppercase mb-3" style={{ color: 'var(--accent)' }}>
            {race.status === 'open' ? '접수중' : race.status === 'closed' ? '마감' : race.status}
          </div>
          <h1 className="text-3xl md:text-5xl font-black uppercase mb-4 leading-tight">{race.title}</h1>
          <div className="flex flex-wrap gap-4 text-sm" style={{ color: 'var(--text-secondary)' }}>
            <span className="flex items-center gap-1.5">
              <iconify-icon icon="solar:map-point-bold" width="16"></iconify-icon>
              {race.location}
            </span>
            {edition?.start_at && (
              <span className="flex items-center gap-1.5">
                <iconify-icon icon="solar:calendar-bold" width="16"></iconify-icon>
                {new Date(edition.start_at).toLocaleDateString('ko-KR', { year: 'numeric', month: 'long', day: 'numeric' })}
              </span>
            )}
          </div>
        </div>

        {/* 기록 찾기 CTA — 핵심 */}
        <div className="rounded-2xl p-8 mb-8 text-center"
          style={{ background: 'linear-gradient(135deg, rgba(232,255,42,0.08) 0%, rgba(232,255,42,0.03) 100%)', border: '1px solid rgba(232,255,42,0.25)' }}>
          <div className="text-xs font-bold tracking-widest uppercase mb-3" style={{ color: 'var(--accent)' }}>
            내 기록 확인
          </div>
          <div className="text-5xl font-black mb-2" style={{ fontFamily: 'Paperlogy, monospace', color: 'var(--accent)' }}>
            00:00:00
          </div>
          <p className="text-sm mb-6" style={{ color: 'var(--text-secondary)' }}>
            배번호 또는 이름으로 나의 공식 기록을 확인하세요
          </p>
          <Link href={`/races/${params.id}/results`}
            className="inline-flex items-center gap-2 px-8 py-4 rounded-xl font-black text-lg transition-all hover:scale-105"
            style={{ backgroundColor: 'var(--accent)', color: '#0a0a0a' }}>
            <iconify-icon icon="solar:running-bold" width="22"></iconify-icon>
            내 기록 찾기
          </Link>
        </div>

        {/* 대회 정보 */}
        {race.description && (
          <div className="rounded-2xl p-6 mb-6" style={{ backgroundColor: 'var(--bg-surface)', border: '1px solid var(--border)' }}>
            <div className="text-xs font-bold tracking-widest uppercase mb-3" style={{ color: 'var(--text-tertiary)' }}>
              대회 소개
            </div>
            <p className="leading-relaxed" style={{ color: 'var(--text-secondary)' }}>{race.description}</p>
          </div>
        )}

        {/* 참가 현황 */}
        {edition && (
          <div className="rounded-2xl p-6 mb-6" style={{ backgroundColor: 'var(--bg-surface)', border: '1px solid var(--border)' }}>
            <div className="text-xs font-bold tracking-widest uppercase mb-4" style={{ color: 'var(--text-tertiary)' }}>
              참가 현황
            </div>
            <div className="flex items-end justify-between mb-3">
              <span className="text-3xl font-black" style={{ fontFamily: 'Paperlogy, monospace', color: 'var(--accent)' }}>
                {edition.registered_count?.toLocaleString() || 0}
              </span>
              <span className="text-sm" style={{ color: 'var(--text-tertiary)' }}>
                / {edition.max_participants?.toLocaleString() || 0}명
              </span>
            </div>
            <div className="h-2 rounded-full overflow-hidden" style={{ backgroundColor: 'rgba(255,255,255,0.05)' }}>
              <div className="h-full rounded-full transition-all" style={{ width: `${progressPct}%`, backgroundColor: 'var(--accent)' }} />
            </div>
            <div className="mt-2 text-xs" style={{ color: 'var(--text-tertiary)' }}>
              {progressPct}% 달성
            </div>
          </div>
        )}

        {/* 접수 기간 */}
        {(race.registration_start || race.registration_end) && (
          <div className="rounded-2xl p-6" style={{ backgroundColor: 'var(--bg-surface)', border: '1px solid var(--border)' }}>
            <div className="text-xs font-bold tracking-widest uppercase mb-4" style={{ color: 'var(--text-tertiary)' }}>
              접수 기간
            </div>
            <div className="flex items-center gap-3 text-sm">
              <span style={{ color: 'var(--text-secondary)' }}>
                {race.registration_start ? new Date(race.registration_start).toLocaleDateString('ko-KR') : '-'}
              </span>
              <span style={{ color: 'var(--text-tertiary)' }}>→</span>
              <span style={{ color: 'var(--text-secondary)' }}>
                {race.registration_end ? new Date(race.registration_end).toLocaleDateString('ko-KR') : '-'}
              </span>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
