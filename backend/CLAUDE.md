# Runner's Connect - Claude 개발 지침

## 프로젝트 개요

**Runner's Connect**는 축제/행사 기획사를 위한 B2B 대회 운영 관리 플랫폼입니다.

## 상위 브랜드
계발자들 (Vibers) — vibers.co.kr / server.vibers.co.kr

### 핵심 비즈니스 모델
- 주최자들에게 대회 백오피스 제공 (SaaS)
- 관리자가 Claude와 함께 맞춤형 대회 홈페이지 제작
- 포스터 OCR 자동 입력 기능 (독자적 차별화 요소)
- 투명한 정산 시스템 (5% 수수료 + 500원/참가자)

### 타겟 고객
- 벚꽃러닝 같은 커뮤니티 기반 주최자
- 축제 및 행사 기획사 (러닝 대회 추가 운영)
- 지자체 문화관광 부서 (지역 마라톤 대회)

---

## 개발 원칙

### 1. 한국어 우선 (Korean-First)

**모든 사용자 대면 텍스트는 한국어로 작성**

```ruby
# ✅ 좋은 예
flash[:success] = '상품이 등록되었습니다.'
validates :name, presence: { message: '상품명을 입력해주세요' }

# ❌ 나쁜 예
flash[:success] = 'Product created successfully'
validates :name, presence: true  # 기본 영문 메시지
```

**적용 대상:**
- View 템플릿의 모든 텍스트 (레이블, 버튼, 제목, 설명)
- Flash 메시지
- Validation 에러 메시지
- 이메일 템플릿
- 주석 (코드 설명이 필요한 경우)

**예외:**
- 코드 변수명, 메서드명, 클래스명 (영문 사용)
- Git 커밋 메시지 (영문 사용)
- 기술 문서 내부 용어

---

### 2. 완전한 구현 (Complete Implementation)

**기능은 반드시 컨트롤러 + 뷰 + 라우팅 + 테스트 가능한 상태까지 완성**

한 기능을 구현할 때 다음을 모두 포함:
- [ ] 컨트롤러 액션 (CRUD)
- [ ] 뷰 템플릿 (index, new, edit, show)
- [ ] 라우팅 설정
- [ ] 모델 관계 및 검증
- [ ] 권한 검증 (before_action)
- [ ] Flash 메시지
- [ ] 브라우저에서 테스트 가능

**예시:**
```ruby
# 상품 관리 기능을 만든다면
# 1. Controller: app/controllers/organizer/products_controller.rb
# 2. Views: app/views/organizer/products/index.html.erb, new.html.erb, edit.html.erb
# 3. Routes: config/routes.rb에 resources :products 추가
# 4. 권한: before_action :authorize_race_access!
# 5. 테스트: 브라우저에서 /organizer/races/:race_id/products 접근 확인
```

---

### 3. Tailwind CSS 디자인 일관성

**프로젝트 전체에서 일관된 디자인 시스템 사용**

#### 색상 팔레트
- **Primary**: `bg-indigo-600`, `hover:bg-indigo-700`
- **Success**: `bg-green-600`, `text-green-600`
- **Warning**: `bg-yellow-500`, `text-yellow-800`
- **Danger**: `bg-red-600`, `text-red-600`
- **Neutral**: `bg-gray-900`, `text-gray-700`, `border-gray-200`

#### 반복 사용 패턴
```html
<!-- 카드 -->
<div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-8">

<!-- 주요 버튼 -->
<button class="px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-lg transition-colors">

<!-- 입력 필드 -->
<input class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent">

<!-- 배지 -->
<span class="px-3 py-1 bg-green-50 text-green-600 text-xs font-bold rounded-full uppercase">

<!-- 테이블 -->
<table class="w-full">
  <thead class="bg-gray-50 border-b border-gray-200">
    <th class="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">
```

#### 반응형 그리드
```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
```

---

### 4. Rails 컨벤션 준수

#### 컨트롤러 구조
```ruby
class Organizer::ProductsController < Organizer::BaseController
  before_action :set_race
  before_action :authorize_race_access!
  before_action :set_product, only: [:edit, :update, :destroy]

  def index
    @products = @race.products.order(created_at: :desc)
  end

  # ... CRUD actions

  private

  def set_race
    @race = current_organizer_profile.races.find(params[:race_id])
  end

  def set_product
    @product = @race.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :status, images: [])
  end

  def authorize_race_access!
    return if current_user.admin?
    return if @race.organizer.user_id == current_user.id
    redirect_to organizer_root_path, alert: '접근 권한이 없습니다.'
  end
end
```

#### 모델 구조
```ruby
class Product < ApplicationRecord
  # Associations
  belongs_to :race
  has_many_attached :images

  # Validations
  validates :name, :price, :stock, presence: true
  validates :price, numericality: { greater_than: 0 }

  # Enums
  enum :status, { active: 'active', inactive: 'inactive', sold_out: 'sold_out' }

  # Scopes
  scope :available, -> { where(status: 'active').where('stock > 0') }

  # Instance Methods
  def available?
    active? && stock > 0
  end
end
```

---

### 5. B2B 멀티 테넌트 아키텍처

**주최자별 데이터 격리 및 권한 관리**

#### 핵심 모델 관계
```
User (role: organizer)
  └─ OrganizerProfile
       ├─ has_many :races
       └─ has_many :settlements

Race
  ├─ belongs_to :organizer (OrganizerProfile)
  ├─ has_many :products
  ├─ has_many :registrations
  └─ has_many :race_editions
```

#### 권한 검증 패턴
```ruby
# Organizer는 자신의 대회만 접근
def set_race
  @race = current_organizer_profile.races.find(params[:race_id])
end

# Admin은 모든 대회 접근
def authorize_race_access!
  return if current_user.admin?
  return if @race.organizer.user_id == current_user.id
  redirect_to organizer_root_path, alert: '접근 권한이 없습니다.'
end
```

---

### 6. 정산 시스템 비즈니스 로직

**수수료 계산 공식**
```ruby
# 5% 플랫폼 수수료 + 참가자당 500원
commission_rate = 0.05
commission_per_registration = 500

platform_commission = (total_revenue * commission_rate).to_i +
                      (registration_count * commission_per_registration)
organizer_payout = total_revenue - platform_commission
```

**정산 상태 흐름**
```
pending (생성)
  ↓ 주최자 요청
confirmed (정산 요청)
  ↓ Admin 승인
approved (승인 완료)
  ↓ Admin 지급 처리
paid (지급 완료)

또는

rejected (거부)
```

---

### 7. 파일 구조 및 네이밍

#### 컨트롤러
```
app/controllers/
├── admin/
│   ├── dashboard_controller.rb
│   ├── races_controller.rb
│   └── settlements_controller.rb
├── organizer/
│   ├── base_controller.rb
│   ├── dashboard_controller.rb
│   ├── products_controller.rb
│   ├── settlements_controller.rb
│   └── races/
│       ├── participants_controller.rb
│       └── records_controller.rb
└── application_controller.rb
```

#### 뷰
```
app/views/
├── admin/
│   ├── dashboard/
│   │   └── index.html.erb
│   ├── races/
│   │   ├── index.html.erb
│   │   ├── new.html.erb
│   │   └── edit.html.erb
│   └── settlements/
│       └── index.html.erb
└── organizer/
    ├── products/
    │   ├── index.html.erb
    │   ├── new.html.erb
    │   └── edit.html.erb
    └── settlements/
        ├── index.html.erb
        └── show.html.erb
```

---

### 8. 주요 기능 체크리스트

#### 신규 기능 구현 시
- [ ] 관련 이슈 및 요구사항 확인
- [ ] 데이터 모델 설계 (마이그레이션)
- [ ] 컨트롤러 및 라우팅 작성
- [ ] 뷰 템플릿 작성 (한국어)
- [ ] 권한 검증 추가
- [ ] Flash 메시지 추가 (성공/에러)
- [ ] 브라우저에서 실제 테스트
- [ ] TodoWrite로 진행 상황 업데이트

#### 코드 리뷰 체크리스트
- [ ] 한국어로 작성되었는가?
- [ ] Tailwind CSS 일관성 유지?
- [ ] 권한 검증이 있는가?
- [ ] N+1 쿼리 방지 (includes 사용)?
- [ ] Strong Parameters 사용?
- [ ] Flash 메시지 추가?

---

### 9. 자주 사용하는 패턴

#### CSV 업로드
```ruby
def bulk_upload
  csv_text = params[:file].read.force_encoding('UTF-8')
  csv = CSV.parse(csv_text, headers: true)

  success_count = 0
  errors = []

  csv.each do |row|
    # 처리 로직
    if record.save
      success_count += 1
    else
      errors << "#{row['식별자']}: #{record.errors.full_messages.join(', ')}"
    end
  end

  flash[:success] = "#{success_count}건 업로드 완료"
  flash[:error] = errors.join(', ') if errors.any?
  redirect_to index_path
end
```

#### 이미지 업로드 (Active Storage)
```ruby
# Model
has_many_attached :images

# Controller
def product_params
  params.require(:product).permit(:name, :description, images: [])
end

# View
<%= f.file_field :images, multiple: true, accept: 'image/*' %>
```

#### 페이지네이션 (Kaminari)
```ruby
# Controller
@products = @race.products.page(params[:page]).per(50)

# View
<%= paginate @products %>
```

---

### 10. 금지 사항

❌ **절대 하지 말 것**
- 영문 사용자 메시지
- 인라인 스타일 (style="...")
- SQL Injection 위험 (raw SQL 사용 시 주의)
- 권한 검증 없는 Admin/Organizer 액션
- 하드코딩된 URL (항상 _path 헬퍼 사용)
- Mass assignment 취약점 (Strong Parameters 필수)

---

## 개발 워크플로우

### 1. 기능 구현
```bash
# 1. 마이그레이션 생성
bin/rails g migration CreateProducts

# 2. 마이그레이션 실행
bin/rails db:migrate

# 3. 모델 및 컨트롤러 작성

# 4. 라우팅 추가

# 5. 뷰 작성

# 6. 테스트
bin/rails server
# 브라우저에서 확인
```

### 2. 디버깅
```bash
# 로그 확인
tail -f log/development.log

# 콘솔에서 테스트
bin/rails console
> Product.create(name: '테스트', price: 10000, stock: 100)

# 라우팅 확인
bin/rails routes | grep products
```

### 3. 시드 데이터 재생성
```bash
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bin/rails db:drop db:create db:migrate db:seed
```

---

## 참고 자료

### 주요 계정 (Seed Data)
- **Admin**: admin@runnersconnect.com / password123
- **Organizer 1**: organizer@seoul-marathon.com / password123
- **Organizer 2**: organizer@busan-marathon.com / password123
- **참가자**: runner1@example.com ~ runner20@example.com / password123

### 주요 URL
- 홈: http://localhost:4000
- Admin 대시보드: http://localhost:4000/admin
- Organizer 대시보드: http://localhost:4000/organizer
- 정산 관리: http://localhost:4000/admin/settlements

### 기술 스택
- **Backend**: Ruby on Rails 8.1
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS
- **Database**: PostgreSQL
- **File Storage**: Active Storage
- **Authentication**: Devise
- **Image Processing**: ImageMagick, MiniMagick

## 프로젝트 구조
```
runnersconnect/
├── backend/                  ← Rails 서버
│   ├── app/
│   │   ├── controllers/
│   │   │   ├── admin/        ← 관리자 (대시보드, 대회, 정산, 커뮤니티)
│   │   │   ├── organizer/    ← 주최자 (대회관리, 상품, 기록, 정산)
│   │   │   ├── api/v1/       ← JSON API (모바일앱)
│   │   │   └── dashboard/    ← 크루 리더 대시보드
│   │   ├── models/           ← 34개 모델
│   │   ├── views/            ← ERB 템플릿
│   │   ├── serializers/      ← API 시리얼라이저
│   │   ├── assets/stylesheets/
│   │   │   ├── application.tailwind.css
│   │   │   └── shadcn.css    ← shadcn-ui 컬러 토큰
│   │   └── components/ui/    ← UI 컴포넌트
│   ├── config/
│   │   ├── routes.rb         ← Web + API 이중 라우팅
│   │   └── database.yml
│   ├── db/migrate/           ← 15+ 마이그레이션
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── CLAUDE.md             ← 이 파일
│   └── OKR.md
├── .github/workflows/
│   └── deploy.yml            ← NCP 배포
└── docs/                     ← 문서
```

---

## OKR 기반 개발 원칙

### OKR이란?
**Objectives and Key Results** - 구글과 실리콘밸리에서 사용하는 목표 관리 체계로, Runner's Connect의 모든 개발은 OKR에 기반하여 진행됩니다.

### OKR 구조
```
Objective (목표)
  ↓ 가슴 뛰는 비전
Key Results (핵심 결과)
  ↓ 측정 가능한 성과
Initiatives (실행 방안)
  ↓ 구체적인 작업
```

### 핵심 원칙

#### 1. Output이 아닌 Outcome에 집중
```ruby
# ❌ 잘못된 예 (Output - 무엇을 했는가)
KR: "정산 관리 페이지 3개 만들기"
KR: "코드 5,000줄 작성하기"
KR: "회의 5번 진행하기"

# ✅ 올바른 예 (Outcome - 어떤 결과가 나타났는가)
KR: "주최자 업무 시간 70% 단축"
KR: "정산 만족도 95% 달성"
KR: "플랫폼 완성도 93% 달성"
```

#### 2. 측정 가능한 지표 사용
모든 Key Result는 숫자, %, 시간 등으로 측정 가능해야 합니다.

```ruby
# ❌ 측정 불가능
KR: "사용자 경험 개선"
KR: "코드 품질 향상"

# ✅ 측정 가능
KR: "페이지 로딩 속도 3초 이내"
KR: "코드 커버리지 80% 이상"
```

#### 3. 도전적인 목표 설정
- 70% 달성만 해도 성공이라고 느낄 만큼 야심찬 목표
- 100% 달성이 쉬운 목표는 OKR이 아님

### 개발 시 OKR 적용 방법

#### 신규 기능 개발 전
1. **OKR.md 파일 확인**: 현재 분기 목표와 정렬되는지 확인
2. **Objective 질문**: "이 기능이 사용자에게 주는 가치는?"
3. **KR 확인**: "이 작업으로 어떤 지표가 개선되는가?"
4. **우선순위 판단**: 현재 OKR 달성에 가장 중요한 작업은?

#### 코드 작성 중
```ruby
# Before: 단순 구현
def create
  @product = Product.create(product_params)
  redirect_to products_path
end

# After: OKR 기반 사고
def create
  @product = @race.products.build(product_params)

  # KR 1 기여: 주최자 업무 시간 단축
  if @product.save
    # 성공 메시지로 사용자 경험 개선
    flash[:success] = '상품이 등록되었습니다.'
    redirect_to organizer_race_products_path(@race)
  else
    # 명확한 에러 메시지로 재작업 시간 최소화
    flash.now[:error] = @product.errors.full_messages.join(', ')
    render :new
  end
end
```

#### 완료 후 검토
- [ ] 이 기능이 현재 OKR의 어떤 KR에 기여하는가?
- [ ] 측정 가능한 개선이 있는가?
- [ ] 사용자에게 실질적인 가치를 제공하는가?

### OKR 업데이트 주기

#### 주간 (매주 금요일)
- Initiatives 체크리스트 진행률 확인
- 다음 주 우선순위 결정

#### 월간 (매월 중순)
- KR 달성률 측정
- OKR.md 업데이트 로그 작성
- 다음 달 방향성 조정

#### 분기별 (3개월)
- 분기 OKR 최종 평가
- 다음 분기 새로운 Objective 수립

### OKR 참고 문서
- **OKR.md**: 현재 분기 목표 및 진행 상황
- **측정 대시보드**: (향후 구현 예정)

### 실전 예시

#### 상황: "정산 승인 UI를 만들어야 한다"

**❌ OKR 없이 개발**
- 그냥 기능만 구현
- 디자인 대충
- 에러 처리 안 함
- 결과: 기능은 있지만 사용성 낮음

**✅ OKR 기반 개발**
1. **Objective 확인**: "주최자들이 필수 도구로 느끼게 만들기"
2. **KR 연결**: "정산 만족도 95%" 달성을 위해
3. **사용자 가치**: 투명한 정산 내역, 원클릭 승인, 명확한 수수료 표시
4. **결과**: 신뢰할 수 있는 정산 시스템 완성

### 금지 사항

❌ **OKR을 단순 할 일 목록으로 전락시키지 말 것**
- Initiatives는 행동이지만, KR은 결과여야 함
- "페이지 3개 만들기"는 OKR이 아님
- "업무 시간 70% 단축"이 진짜 OKR

❌ **측정 불가능한 목표 설정 금지**
- "좋은 코드 작성"은 OKR이 아님
- "코드 리뷰 통과율 95%"가 OKR

---

## 마무리

이 문서는 Runner's Connect 프로젝트의 일관성을 유지하고, 새로운 기능을 빠르게 구현하기 위한 가이드입니다.

**핵심 기억 사항:**
1. 모든 사용자 대면 텍스트는 한국어
2. Tailwind CSS로 일관된 디자인
3. 완전한 구현 (컨트롤러 + 뷰 + 라우팅 + 테스트)
4. B2B 멀티 테넌트 아키텍처
5. 투명한 정산 시스템
6. **OKR 기반 개발**: Output이 아닌 Outcome, 측정 가능한 성과

**필수 참고 문서:**
- **CLAUDE.md** (이 문서): 개발 원칙 및 가이드라인
- **OKR.md**: 현재 분기 목표 및 핵심 결과

문의 사항이 있으면 이 문서를 참고하고, 불명확한 부분은 기존 코드의 패턴을 따르세요.

---

## NCP 서버 정보
- **IP**: 49.50.138.93
- **SSH**: ssh root@49.50.138.93
- **프로젝트 경로**: /root/projects/runnersconnect/
- **Docker 네트워크**: npm_default

## 포트맵
| 포트 | 컨테이너명 | 도메인 |
|------|-----------|--------|
| 4070 | runnersconnect-api | runnersconnect.vibers.co.kr |

## Docker Compose 규칙
- 컨테이너명: runnersconnect-api, runnersconnect-db
- DB: postgres:16-alpine
- 네트워크: npm_default (external: true) + internal
- restart: unless-stopped
- 환경변수: .env 파일로 관리

## 배포 방식
- `.github/workflows/deploy.yml` (GitHub Actions)
- `git push origin main` → SSH → Docker Compose 재빌드
- GitHub Secrets: NCP_HOST, NCP_USER, NCP_SSH_KEY

## SSL 절대 규칙
- Cloudflare Full Mode (주황구름 ON)
- NPM에서 Let's Encrypt 발급하지 마!
- NPM에서는 HTTP 프록시만 설정
- server, *.server 만 DNS Only (회색구름)

## 멀티 에이전트 협업 체계

| 태그 | 환경 | 역할 |
|------|------|------|
| [AG] | AntiGravity (VS Code 익스텐션) | 코딩 메인. LEO가 직접 지시 |
| [CC] | Claude Code (VS Code) | 단일 앱 작업 |
| [TCC] | Claude Code (터미널 / iTerm2) | 병렬 작업 |
| [APP] | Claude Code (앱, 클라우드) | 보조 작업 |
| [CW] | Claude Cowork (데스크톱) | 비코딩 (서버 관리, 문서) |

## 디자인 특징
- Primary: Indigo-600 (bg-indigo-600, hover:bg-indigo-700)
- shadcn-ui 컬러 시스템 (CSS 변수 기반)
- 레이싱 시맨틱 컬러 (live, upcoming, closed)
→ 상세 내용은 DESIGN_GUIDE.md 참조

## 현재 작업 (NOW)
<!-- 작업 중단 시 여기에 기록 — 다음 에이전트가 이어받을 수 있도록 -->
- 진행 중: 없음
- 마지막 완료: NCP Docker 배포 완료 (2026-03-24)
- 다음 할 일: OKR.md의 KR 기준으로 우선순위 높은 것부터
