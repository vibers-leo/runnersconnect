'use client';

import { useState } from 'react';
import Link from 'next/link';

interface RecordData {
  bib_number: string;
  name: string;
  race_title: string;
  race_date: string;
  location: string;
  net_time: string;
  net_time_display: string;
  gun_time: string;
  gun_time_display: string;
  rank_overall: number | null;
  rank_gender: number | null;
  rank_age: number | null;
  splits: Record<string, string> | null;
  is_verified: boolean;
  has_record: boolean;
}

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'https://runnersconnect.vibers.co.kr';

export default function ResultsPage({ params }: { params: { id: string } }) {
  const [searchType, setSearchType] = useState<'bib' | 'name'>('bib');
  const [query, setQuery] = useState('');
  const [loading, setLoading] = useState(false);
  const [record, setRecord] = useState<RecordData | null>(null);
  const [results, setResults] = useState<RecordData[]>([]);
  const [error, setError] = useState('');
  const [searched, setSearched] = useState(false);

  const handleSearch = async () => {
    if (!query.trim()) return;
    setLoading(true);
    setError('');
    setRecord(null);
    setResults([]);
    setSearched(true);

    try {
      const param = searchType === 'bib' ? `bib=${query.trim()}` : `name=${encodeURIComponent(query.trim())}`;
      const res = await fetch(`${API_BASE}/api/v1/races/${params.id}/results?${param}`);
      const data = await res.json();

      if (!res.ok) {
        setError(data.error || '기록을 찾을 수 없습니다.');
        return;
      }

      if (data.results) {
        setResults(data.results);
      } else {
        setRecord(data);
      }
    } catch {
      setError('서버 연결에 실패했습니다. 잠시 후 다시 시도해주세요.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen" style={{ backgroundColor: 'var(--bg-main)' }}>
      <div className="max-w-3xl mx-auto px-6 py-16">

        {/* 헤더 */}
        <div className="mb-12">
          <Link href={`/races/${params.id}`} className="nav-link inline-flex items-center gap-1 text-sm mb-6">
            <iconify-icon icon="solar:arrow-left-bold" width="16"></iconify-icon>
            대회 정보로
          </Link>
          <div className="text-xs font-bold tracking-widest uppercase mb-3" style={{ color: 'var(--accent)' }}>
            RESULTS
          </div>
          <h1 className="text-3xl md:text-4xl font-black uppercase mb-3">내 기록 찾기</h1>
          <p style={{ color: 'var(--text-secondary)' }}>
            배번호 또는 이름으로 나의 기록을 확인하세요.
          </p>
        </div>

        {/* 검색 */}
        <div className="rounded-2xl p-6 mb-8" style={{ backgroundColor: 'var(--bg-surface)', border: '1px solid var(--border)' }}>
          {/* 탭 */}
          <div className="flex gap-2 mb-5">
            {(['bib', 'name'] as const).map((type) => (
              <button key={type} onClick={() => setSearchType(type)}
                className="px-4 py-2 rounded-lg text-sm font-bold transition-all"
                style={{
                  backgroundColor: searchType === type ? 'var(--accent)' : 'rgba(255,255,255,0.05)',
                  color: searchType === type ? '#0a0a0a' : 'var(--text-secondary)',
                }}>
                {type === 'bib' ? '배번호로 검색' : '이름으로 검색'}
              </button>
            ))}
          </div>

          <div className="flex gap-3">
            <input
              type={searchType === 'bib' ? 'number' : 'text'}
              value={query}
              onChange={e => setQuery(e.target.value)}
              onKeyDown={e => e.key === 'Enter' && handleSearch()}
              placeholder={searchType === 'bib' ? '배번호 입력 (예: 42)' : '이름 입력 (예: 홍길동)'}
              className="flex-1 px-4 py-3 rounded-xl text-lg font-bold bg-transparent outline-none"
              style={{
                backgroundColor: 'rgba(255,255,255,0.05)',
                border: '1px solid var(--border)',
                color: 'var(--text-main)',
              }}
            />
            <button onClick={handleSearch} disabled={loading || !query.trim()}
              className="px-6 py-3 rounded-xl font-bold transition-all hover:scale-105 disabled:opacity-40 disabled:scale-100"
              style={{ backgroundColor: 'var(--accent)', color: '#0a0a0a' }}>
              {loading ? (
                <iconify-icon icon="solar:refresh-bold" width="20" className="animate-spin"></iconify-icon>
              ) : (
                <iconify-icon icon="solar:magnifer-bold" width="20"></iconify-icon>
              )}
            </button>
          </div>
        </div>

        {/* 에러 */}
        {error && (
          <div className="rounded-2xl p-5 mb-6 flex items-center gap-3"
            style={{ backgroundColor: 'rgba(255,80,80,0.08)', border: '1px solid rgba(255,80,80,0.2)' }}>
            <iconify-icon icon="solar:close-circle-bold" width="20" style={{ color: '#ff5050' }}></iconify-icon>
            <span style={{ color: '#ff8080' }}>{error}</span>
          </div>
        )}

        {/* 단일 기록 카드 */}
        {record && <RecordCard record={record} />}

        {/* 이름 검색 결과 목록 */}
        {results.length > 0 && (
          <div>
            <div className="text-sm mb-4" style={{ color: 'var(--text-secondary)' }}>
              {results.length}명의 결과가 있습니다
            </div>
            <div className="flex flex-col gap-4">
              {results.map((r, i) => (
                <RecordCard key={i} record={r} compact />
              ))}
            </div>
          </div>
        )}

        {/* 검색 결과 없음 */}
        {searched && !loading && !error && !record && results.length === 0 && (
          <div className="text-center py-16" style={{ color: 'var(--text-tertiary)' }}>
            <iconify-icon icon="solar:running-bold" width="48" style={{ marginBottom: '12px', opacity: 0.3 }}></iconify-icon>
            <p>검색 결과가 없습니다.</p>
          </div>
        )}
      </div>
    </div>
  );
}

function RecordCard({ record, compact = false }: { record: RecordData; compact?: boolean }) {
  const handlePrint = () => window.print();

  if (!record.has_record) {
    return (
      <div className="rounded-2xl p-6 mb-4" style={{ backgroundColor: 'var(--bg-surface)', border: '1px solid var(--border)' }}>
        <div className="flex items-center gap-3 mb-2">
          <span className="text-xl font-black" style={{ fontFamily: 'Paperlogy, monospace', color: 'var(--accent)' }}>
            #{record.bib_number}
          </span>
          <span className="font-bold">{record.name}</span>
        </div>
        <p className="text-sm" style={{ color: 'var(--text-secondary)' }}>
          기록이 아직 등록되지 않았습니다. 대회 종료 후 기록이 업로드됩니다.
        </p>
      </div>
    );
  }

  return (
    <div className={`rounded-2xl overflow-hidden ${compact ? 'mb-3' : 'mb-6'} print:shadow-none`}
      style={{ backgroundColor: 'var(--bg-surface)', border: '1px solid var(--border)' }}>

      {/* 상단 강조 바 */}
      <div className="h-1" style={{ backgroundColor: 'var(--accent)' }} />

      <div className="p-6 md:p-8">
        {/* 대회 정보 */}
        <div className="flex items-start justify-between mb-6">
          <div>
            <div className="text-xs font-bold tracking-widest uppercase mb-1" style={{ color: 'var(--accent)' }}>
              OFFICIAL RECORD
            </div>
            <div className="font-bold" style={{ color: 'var(--text-secondary)' }}>{record.race_title}</div>
            <div className="text-sm" style={{ color: 'var(--text-tertiary)' }}>
              {record.race_date} · {record.location}
            </div>
          </div>
          {record.is_verified && (
            <div className="flex items-center gap-1 text-xs font-bold px-2.5 py-1 rounded-full"
              style={{ backgroundColor: 'rgba(232,255,42,0.1)', color: 'var(--accent)', border: '1px solid rgba(232,255,42,0.2)' }}>
              <iconify-icon icon="solar:verified-check-bold" width="12"></iconify-icon>
              공인 기록
            </div>
          )}
        </div>

        {/* 배번호 + 이름 */}
        <div className="flex items-baseline gap-4 mb-6">
          <span className="text-6xl md:text-7xl font-black" style={{ fontFamily: 'Paperlogy, monospace', color: 'var(--accent)' }}>
            #{record.bib_number}
          </span>
          <span className="text-2xl font-black">{record.name}</span>
        </div>

        {/* 핵심: 기록 — 크게 */}
        <div className="rounded-2xl p-6 mb-6 text-center"
          style={{ backgroundColor: 'rgba(232,255,42,0.05)', border: '1px solid rgba(232,255,42,0.15)' }}>
          <div className="text-xs font-bold tracking-widest uppercase mb-2" style={{ color: 'var(--text-tertiary)' }}>
            NET TIME (순 기록)
          </div>
          <div className="text-6xl md:text-7xl font-black tracking-tight"
            style={{ fontFamily: 'Paperlogy, monospace', color: 'var(--accent)' }}>
            {record.net_time_display}
          </div>
          {record.gun_time_display && record.gun_time_display !== record.net_time_display && (
            <div className="mt-2 text-sm" style={{ color: 'var(--text-tertiary)' }}>
              건타임 {record.gun_time_display}
            </div>
          )}
        </div>

        {/* 등수 — 작게, 참고용 */}
        {(record.rank_overall || record.rank_gender || record.rank_age) && (
          <div className="grid grid-cols-3 gap-3 mb-6">
            {[
              { label: '종합 순위', value: record.rank_overall },
              { label: '성별 순위', value: record.rank_gender },
              { label: '연령대 순위', value: record.rank_age },
            ].map((item, i) => item.value && (
              <div key={i} className="text-center p-3 rounded-xl"
                style={{ backgroundColor: 'rgba(255,255,255,0.04)', border: '1px solid var(--border)' }}>
                <div className="text-xs mb-1" style={{ color: 'var(--text-tertiary)' }}>{item.label}</div>
                <div className="font-black text-lg" style={{ fontFamily: 'Paperlogy, monospace' }}>
                  {item.value}<span className="text-xs font-normal ml-0.5" style={{ color: 'var(--text-tertiary)' }}>위</span>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* 구간 기록 */}
        {record.splits && Object.keys(record.splits).length > 0 && (
          <div className="mb-6">
            <div className="text-xs font-bold tracking-widest uppercase mb-3" style={{ color: 'var(--text-tertiary)' }}>
              SPLITS
            </div>
            <div className="flex flex-col gap-2">
              {Object.entries(record.splits).map(([point, time], i) => (
                <div key={i} className="flex items-center justify-between py-2"
                  style={{ borderBottom: '1px solid var(--border)' }}>
                  <span className="text-sm" style={{ color: 'var(--text-secondary)' }}>{point}</span>
                  <span className="font-bold text-sm" style={{ fontFamily: 'Paperlogy, monospace' }}>{time}</span>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* 액션 버튼 */}
        {!compact && (
          <div className="flex gap-3 pt-2">
            <button onClick={handlePrint}
              className="flex-1 flex items-center justify-center gap-2 py-3 rounded-xl font-bold text-sm transition-all hover:scale-[1.02]"
              style={{ backgroundColor: 'var(--accent)', color: '#0a0a0a' }}>
              <iconify-icon icon="solar:printer-bold" width="18"></iconify-icon>
              기록 인쇄
            </button>
            {record.certificate_url && (
              <a href={record.certificate_url} target="_blank" rel="noopener noreferrer"
                className="flex-1 flex items-center justify-center gap-2 py-3 rounded-xl font-bold text-sm transition-all hover:scale-[1.02]"
                style={{ border: '1px solid var(--border)', color: 'var(--text-main)' }}>
                <iconify-icon icon="solar:diploma-bold" width="18"></iconify-icon>
                완주증명서 다운로드
              </a>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
