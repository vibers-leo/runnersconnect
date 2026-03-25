# Runner's Connect Design System (V2.0)

## 🎨 색상 시스템

### Core Brand Colors
- **Primary**: `hsl(217 91% 60%)` - #3B82F6 (Energetic Blue)
  - 주요 버튼, 링크, 액센트에 사용
  - 생동감 있고 신뢰감을 주는 블루
- **Accent**: `hsl(189 94% 43%)` - #06B6D4 (Electric Teal)
  - 보조 액센트, 그라디언트에 사용
  - Primary와 함께 사용하여 생동감 추가

### Semantic Colors
- **Success**: `hsl(142 71% 45%)` - #22C55E (Fresh Green)
  - 성공 메시지, 완료 상태, PB 달성
- **Warning**: `hsl(38 92% 50%)` - #F59E0B (Amber Alert)
  - 경고 메시지, 마감 임박 알림
- **Destructive**: `hsl(0 84% 60%)` - #EF4444 (Refined Red)
  - 에러 메시지, 삭제 액션, 위험 경고

### Running-Specific Colors
- **race-live**: Green (#22C55E) - 진행 중인 레이스
- **race-upcoming**: Blue (#3B82F6) - 예정된 레이스
- **race-closed**: Gray (#94A3B8) - 종료된 레이스
- **race-sold-out**: Red (#EF4444) - 매진된 레이스

### Background & Text
- **Background**: Pure White (#FFFFFF)
- **Foreground**: Slate-900 (#0F172A)
- **Muted Foreground**: Slate-400 (#94A3B8) - 보조 텍스트
- **Border**: Slate-200 (#E2E8F0) - 부드러운 보더

---

## 📝 타이포그래피

### Font Family
- **Primary**: Inter (본문 및 UI)
- **Mono**: JetBrains Mono (숫자, 통계)

### Type Scale
- **Display**: 48-72px, font-black, tracking-tighter
  - Hero 헤드라인에 사용
- **H1**: 36px, font-bold, tracking-tight
- **H2**: 30px, font-bold
- **H3**: 24px, font-semibold
- **H4**: 20px, font-semibold
- **Body**: 16px, font-normal, leading-relaxed
- **Caption**: 14px, font-medium
- **Label**: 12px, font-semibold, uppercase, tracking-widest

### Usage Guidelines
```
Hero 타이틀: text-5xl md:text-7xl font-black tracking-tight
섹션 제목: text-3xl font-bold
카드 제목: text-lg font-semibold
본문: text-base leading-relaxed
통계 숫자: text-5xl font-black font-mono text-primary
```

---

## 📐 레이아웃 & 간격

### Container Sizes
- **Homepage Hero**: `max-w-7xl` (1280px) - 더 넓은 여백
- **Standard Pages**: `max-w-6xl` (1152px) - 일반 페이지
- **Content Pages**: `max-w-4xl` (896px) - 읽기 콘텐츠
- **Forms**: `max-w-2xl` (672px) - 등록 폼

### Vertical Rhythm
- **Page Padding**: `py-16 md:py-24` (64px/96px)
- **Section Spacing**: `space-y-16 md:space-y-24`
- **Card Internal**: `p-6 md:p-8` (24px/32px)
- **Component Gaps**:
  - Small: `gap-4` (16px)
  - Medium: `gap-6` (24px)
  - Large: `gap-8` (32px)

### Grid System
- **Mobile**: Single column stack
- **Tablet (md)**: 2 columns for cards
- **Desktop (lg)**: 3 columns for race cards
- **Wide (xl)**: Max 4 columns (avoid overwhelming)

---

## 🎭 컴포넌트 스타일

### Border Radius
- **Cards**: `rounded-2xl` (16px)
- **Buttons/Inputs**: `rounded-xl` (12px)
- **Modals/Dialogs**: `rounded-2xl` (16px)
- **Tags/Badges**: `rounded-full`

### Shadows
- **Small**: `shadow-sm` - Subtle elevation
- **Medium**: `shadow-md` - Standard cards
- **Large**: `shadow-lg` - Elevated states
- **X-Large**: `shadow-xl` - Floating elements

### Transitions
- **Fast**: 150ms - Small interactions
- **Base**: 200ms - Standard (default)
- **Slow**: 300ms - Complex animations
- **Slower**: 500ms - Image scales

---

## ✨ 애니메이션 & 인터랙션

### Hover Effects
```css
/* Cards */
hover:shadow-xl hover:-translate-y-2 transition-all duration-300

/* Buttons */
hover:scale-[1.02] active:scale-[0.98] transition-transform duration-200

/* Links */
hover:text-primary transition-all duration-200

/* Images */
group-hover:scale-105 transition-transform duration-500
```

### Loading States
- **Skeleton**: shimmer gradient animation
- **Spinner**: rotate animation
- **Pulse**: opacity animation

### Entrance Animations
- **Slide Up**: `animate-slide-up`
- **Slide Down**: `animate-slide-down`
- **Fade In**: `animate-fade-in`
- **Scale In**: `animate-scale-in`

### Focus States
- **All Interactive Elements**: `focus-visible:ring-2 focus-visible:ring-primary`
- **Ring Offset**: `ring-offset-2`
- **Ring Color**: Matches primary color

---

## 🎯 컴포넌트별 가이드

### Buttons
```html
<!-- Primary -->
<button class="h-12 px-6 rounded-xl bg-primary text-white hover:bg-primary/90 hover:scale-[1.02] active:scale-[0.98] transition-all duration-200 shadow-sm">

<!-- Secondary -->
<button class="h-12 px-6 rounded-xl bg-secondary border border-border hover:bg-secondary/80">

<!-- Outline -->
<button class="h-12 px-6 rounded-xl border-2 border-input hover:bg-accent hover:border-primary/30">
```

### Cards
```html
<!-- Default -->
<div class="rounded-2xl border bg-card shadow-sm hover:shadow-md hover:border-border/60 transition-all duration-200">

<!-- Interactive -->
<div class="rounded-2xl border bg-card shadow-sm hover:shadow-lg hover:-translate-y-1 cursor-pointer transition-all duration-200">
```

### Inputs
```html
<input class="h-10 w-full rounded-xl border border-input px-3 py-2
              focus-visible:ring-2 focus-visible:ring-primary focus-visible:border-primary
              hover:border-border/60 transition-all duration-200">
```

### Badges
```html
<!-- Success -->
<span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold bg-green-100 text-green-800 border border-green-200">

<!-- Warning -->
<span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold bg-amber-100 text-amber-800 border border-amber-200">
```

---

## 📱 반응형 디자인

### Breakpoints
- **Mobile**: < 768px (sm)
  - Bottom navigation visible
  - Single column layouts
  - Stacked forms
- **Tablet**: 768px - 1024px (md)
  - Top navigation visible
  - 2-column grids
  - Larger touch targets
- **Desktop**: > 1024px (lg)
  - Full navigation
  - 3-4 column grids
  - Footer visible
  - Hover interactions

### Navigation
- **Desktop**: Top sticky header (h-20, py-5)
- **Mobile**: Bottom fixed navigation
- **Footer**: Desktop only (hidden on mobile)

---

## 🎨 CSS Variables

모든 색상은 CSS 변수로 정의되어 있어 일관성과 유지보수성을 보장합니다:

```css
/* 사용 예시 */
bg-primary          → Primary color background
text-primary        → Primary color text
border-border       → Consistent borders
text-muted-foreground → Secondary text
```

---

## ♿ 접근성 (Accessibility)

### 색상 대비
- **Text**: WCAG AA 기준 4.5:1 이상
- **Large Text**: WCAG AA 기준 3:1 이상

### 키보드 네비게이션
- 모든 인터랙티브 요소 접근 가능
- 명확한 focus states
- Skip links 제공

### Touch Targets
- 최소 크기: 44x44px
- 모바일에서 충분한 간격

---

## 🚀 성능 고려사항

1. **CSS Size**: Tailwind purge로 미사용 클래스 제거
2. **Font Loading**: `font-display: swap` 사용
3. **Animations**: GPU 가속 속성만 사용 (transform, opacity)
4. **Images**: Lazy loading for below-fold content
5. **Reduced Motion**: `prefers-reduced-motion` 존중

---

## 📚 추가 리소스

- **Component Helper**: [backend/app/helpers/components_helper.rb](backend/app/helpers/components_helper.rb)
- **CSS Variables**: [backend/app/assets/stylesheets/shadcn.css](backend/app/assets/stylesheets/shadcn.css)
- **Animations**: [backend/app/assets/stylesheets/application.tailwind.css](backend/app/assets/stylesheets/application.tailwind.css)

---

*V2.0 업데이트 (2026) - 모던하고 미니멀한 디자인으로 전면 개선*
*이 가이드는 사이트 전체의 일관성을 위해 지속적으로 유지 및 관리됩니다.*
