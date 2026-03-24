# Runner's Connect — 디자인 가이드

> 상위 브랜드: 계발자들 (Vibers)
> 디자인 아이덴티티: 활동적, 전문적, 신뢰

## 컬러 시스템

### 핵심 컬러 팔레트 (shadcn.css 기반)
| 역할 | 값 | CSS 변수 | 설명 |
|------|-----|---------|------|
| Primary | Indigo-600 (#4F46E5) | --primary | 메인 컬러 |
| Primary Hover | Indigo-700 (#4338CA) | - | 호버 상태 |
| Secondary | Gray-100 | --secondary | 보조 배경 |
| Success | Green-600 (#16A34A) | --success | 승인/완료 |
| Warning | Yellow-500 (#EAB308) | --warning | 대기/주의 |
| Danger | Red-600 (#DC2626) | --destructive | 거절/에러 |
| Background | White | --background | 페이지 배경 |
| Card | White | --card | 카드 배경 |
| Border | Gray-200 (#E5E7EB) | --border | 테두리 |

### 레이싱 시맨틱 컬러
| 역할 | 값 | CSS 변수 | 설명 |
|------|-----|---------|------|
| Live | Red-600 | --race-live | 진행중 대회 |
| Upcoming | Blue-600 | --race-upcoming | 예정 대회 |
| Closed | Gray-500 | --race-closed | 종료 대회 |

### 컬러 사용 규칙
- Primary (Indigo): CTA 버튼, 링크, 선택된 상태
- Success (Green): 결제 완료, 승인, 활성 배지
- Warning (Yellow): 대기 중, 주의 사항
- Danger (Red): 거부, 취소, 삭제
- Neutral (Gray): 배경, 테두리, 비활성 상태

## 타이포그래피

### 폰트 스택
- 한글: system-ui (Apple SD Gothic Neo / Noto Sans KR)
- 영문: system-ui, Inter

### 제목 계층
| 레벨 | Tailwind | 용도 |
|------|---------|------|
| H1 | text-3xl font-bold | 페이지 제목 |
| H2 | text-2xl font-bold | 섹션 제목 |
| H3 | text-xl font-semibold | 카드/서브 제목 |
| H4 | text-lg font-medium | 소 제목 |
| Body | text-base text-gray-700 | 본문 |
| Small | text-sm text-gray-500 | 보조 텍스트 |

## 레이아웃

### 반응형 브레이크포인트
- sm: 640px, md: 768px, lg: 1024px, xl: 1280px

### 그리드 시스템
```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
```

### 카드 구조
```html
<div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-8">
```

## 컴포넌트 패턴

### 버튼
| 스타일 | 클래스 |
|--------|--------|
| Primary | `px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-lg` |
| Outline | `border-2 border-indigo-600 text-indigo-600 hover:bg-indigo-50` |
| Danger | `bg-red-600 hover:bg-red-700 text-white` |
| Ghost | `text-gray-600 hover:bg-gray-100` |

### 배지
```html
<span class="px-3 py-1 bg-green-50 text-green-600 text-xs font-bold rounded-full uppercase">
```

### 테이블
```html
<thead class="bg-gray-50 border-b border-gray-200">
  <th class="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
```

### 입력 필드
```html
<input class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent">
```

### 애니메이션 (application.tailwind.css 기반)
| 이름 | 설명 |
|------|------|
| fade-in | opacity 0→1, translateY 4→0 (0.5s) |
| slide-up | translateY 8→0, opacity (0.6s) |
| scale-in | scale 95→100, opacity (0.4s) |
| shimmer | 스켈레톤 로딩 좌→우 |

## 접근성
- WCAG 2.1 AA 기준
- 키보드 포커스 표시
- 최소 터치 영역 44px
- 다크모드: CSS 변수 지원 (shadcn.css dark theme 정의됨)

---

**마지막 업데이트**: 2026-03-24
