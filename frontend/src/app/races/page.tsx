import Link from 'next/link';

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'https://runnersconnect.vibers.co.kr';

interface Race {
  id: number;
  title: string;
  description: string;
  location: string;
  status: string;
  registration_start: string;
  registration_end: string;
}

async function getRaces(): Promise<Race[]> {
  try {
    const res = await fetch(`${API_BASE}/api/v1/races`, { cache: 'no-store' });
    if (!res.ok) return [];
    const data = await res.json();
    if (data.data) {
      return data.data.map((d: { id: number; attributes: Race }) => ({ id: d.id, ...d.attributes }));
    }
    return data;
  } catch {
    return [];
  }
}

export default async function RacesPage() {
  const races = await getRaces();

  return (
    <div className="min-h-screen" style={{ backgroundColor: 'var(--bg-main)' }}>
      <div className="max-w-5xl mx-auto px-6 py-16">

        {/* 헤더 */}
        <div className="mb-12">
          <div className="text-xs font-bold tracking-widest uppercase mb-3" style={{ color: 'var(--accent)' }}>
            RACES
          </div>
          <h1 className="text-4xl md:text-5xl font-black uppercase mb-4">대회 목록</h1>
          <p style={{ color: 'var(--text-secondary)' }}>
            참가 대회의 공식 기록을 확인하세요.
          </p>
        </div>

        {races.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
            {races.map((race) => (
              <Link key={race.id} href={`/races/${race.id}`}
                className="group rounded-2xl overflow-hidden transition-all hover:scale-[1.02]"
                style={{ backgroundColor: 'var(--bg-surface)', border: '1px solid var(--border)' }}>

                {/* 상단 바 */}
                <div className="h-1" style={{ backgroundColor: race.status === 'open' ? 'var(--accent)' : 'rgba(255,255,255,0.15)' }} />

                <div className="p-6">
                  <div className="flex items-center justify-between mb-4">
                    <span className="text-xs font-bold px-2.5 py-1 rounded-full"
                      style={{
                        backgroundColor: race.status === 'open' ? 'rgba(232,255,42,0.1)' : 'rgba(255,255,255,0.05)',
                        color: race.status === 'open' ? 'var(--accent)' : 'var(--text-tertiary)',
                        border: `1px solid ${race.status === 'open' ? 'rgba(232,255,42,0.2)' : 'var(--border)'}`,
                      }}>
                      {race.status === 'open' ? '접수중' : race.status === 'closed' ? '마감' : race.status}
                    </span>
                    <iconify-icon icon="solar:arrow-right-bold" width="16"
                      className="transition-transform group-hover:translate-x-1"
                      style={{ color: 'var(--text-tertiary)' }}></iconify-icon>
                  </div>

                  <h3 className="text-xl font-black mb-2 group-hover:text-[var(--accent)] transition-colors">
                    {race.title}
                  </h3>

                  <div className="flex items-center gap-1.5 text-sm" style={{ color: 'var(--text-secondary)' }}>
                    <iconify-icon icon="solar:map-point-bold" width="14"></iconify-icon>
                    {race.location}
                  </div>

                  {/* 기록 찾기 힌트 */}
                  <div className="mt-4 pt-4 flex items-center gap-2 text-xs font-bold"
                    style={{ borderTop: '1px solid var(--border)', color: 'var(--accent)' }}>
                    <iconify-icon icon="solar:running-bold" width="14"></iconify-icon>
                    내 기록 확인하기
                  </div>
                </div>
              </Link>
            ))}
          </div>
        ) : (
          <div className="text-center py-24 rounded-2xl" style={{ backgroundColor: 'var(--bg-surface)', border: '1px solid var(--border)' }}>
            <iconify-icon icon="solar:running-bold" width="56" style={{ color: 'var(--text-tertiary)', opacity: 0.3, marginBottom: '16px' }}></iconify-icon>
            <h3 className="text-xl font-black mb-2">아직 등록된 대회가 없습니다</h3>
            <p style={{ color: 'var(--text-secondary)' }}>곧 다양한 대회가 등록될 예정입니다!</p>
          </div>
        )}
      </div>
    </div>
  );
}
