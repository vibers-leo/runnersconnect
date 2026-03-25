# 데이터베이스 구조 명세서 (DB Schema Design) - v0.1

이 문서는 **Runner's Connect** 플랫폼의 확장성과 데이터 무결성을 고려한 스키마 설계입니다.

---

## 1. 핵심 개념

- **정규화:** 대회(Race), 등록(Registration), 기록(Record) 간의 독립성을 유지하되, 이력 관리(Snapshot)가 필요한 경우 별도 테이블에 저장합니다.
- **확장성:** JSON 필드를 활용하여 종목별 세부 옵션, 메타데이터를 유연하게 관리합니다.
- **성능:** 대규모 동시 접속(선착순)을 고려해 인덱스와 상태 머신(State Machine)을 명확히 정의합니다.

---

## 2. 테이블 목록 및 정의 (ERD)

### `users` (회원)

- **설명:** 플랫폼의 모든 사용자 (러너).
- **PK:** `id` (bigint, auto_increment)
- **Fields:**
  - `email` (string, unique, index): 로그인 ID
  - `encrypted_password` (string): Devise 암호화 비밀번호
  - `provider`, `uid` (string): 소셜 로그인 식별자 (복합 index)
  - `name` (string): 실명
  - `phone_number` (string, index): 연락처 (알림톡 발송용)
  - `birth_date` (date): 생년월일 (연령별 순위 집계용)
  - `gender` (enum: `M`, `F`): 성별 (남녀부 시상용)
  - `address_zipcode`, `address_basic`, `address_detail` (string): 기본 배송지
  - `preferred_size` (string): 선호 티셔츠 사이즈
  - `emergency_contact` (string): 비상연락처
  - `role` (enum: `user`, `admin`, `staff`): 권한 레벨
  - `total_distance` (float): 누적 거리 캐싱 (배치 작업으로 업데이트)
  - `total_races` (integer): 누적 완주 횟수 캐싱
  - `created_at`, `updated_at` (datetime)

### `races` (대회)

- **설명:** 주최측이 생성한 마라톤 대회 정보.
- **PK:** `id` (bigint)
- **Fields:**
  - `title` (string): 대회명 (예: "2024 서울 마라톤")
  - `description` (text): 대회 소개 (HTML 또는 Markdown)
  - `location` (string): 개최 장소 (주소)
  - `start_at` (datetime): 대회 시작 일시
  - `registration_start_at`, `registration_end_at` (datetime): 접수 기간
  - `refund_deadline` (datetime): 환불 마감 기한
  - `thumbnail_url` (string): 대표 이미지
  - `status` (enum: `draft`, `open`, `closed`, `finished`): 대회 상태
  - `organizer_name` (string): 주최사명
  - `official_site_url` (string): 공식 홈페이지 링크 (선택)
  - `is_official_record` (boolean): 공인 기록 인정 여부 (default: true)

### `race_editions` (종목 옵션 / 티켓)

- **설명:** 하나의 대회 안에 여러 종목(5K, 10K 등)이 존재함. 이를 `RaceEdition` 또는 `RaceOption`으로 관리.
- **PK:** `id` (bigint)
- **FK:** `race_id` (references `races`)
- **Fields:**
  - `name` (string): 종목명 (예: "10K 코스", "Half 코스")
  - `price` (integer): 참가비 (원화 기준)
  - `capacity` (integer): 최대 모집 인원 (null이면 무제한)
  - `current_count` (integer): 현재 신청 인원 (Redis 또는 Counter Cache 활용)
  - `display_order` (integer): 정렬 순서
  - `age_limit_min`, `age_limit_max` (integer): 나이 제한 (선택)
  - `is_sold_out` (boolean): 품절 여부 플래그

### `crews` (러닝크루 / 단체)

- **설명:** 단체 신청을 위한 그룹 정보.
- **PK:** `id` (bigint)
- **FK:** `leader_id` (references `users`)
- **Fields:**
  - `name` (string): 크루명
  - `code` (string, unique, index): 그룹 가입 코드 (예: `ABC1234`)
  - `description` (text): 크루 소개
  - `member_count` (integer): 멤버 수

### `registrations` (참가 신청)

- **설명:** 사용자가 특정 대회의 종목을 구매한 이력. 가장 중요한 트랜잭션 테이블.
- **PK:** `id` (bigint)
- **FK:** `user_id` (references `users`), `race_edition_id` (references `race_editions`), `crew_id` (references `crews`, nullable)
- **Fields:**
  - `merchant_uid` (string, unique, index): 결제 주문번호 (포트원 연동용)
  - `status` (enum: `pending`, `paid`, `cancelled`, `refunded`): 결제 상태
  - `payment_method` (string): 결제 수단 (card, trans, vbank 등)
  - `payment_amount` (integer): 실제 결제 금액
  - `paid_at` (datetime): 결제 완료 일시
  - `bib_number` (string): 배번호 (결제 완료 후 배정)
  - `tshirt_size` (string): 선택한 티셔츠 사이즈 (Snapshot)
  - `shipping_status` (enum: `preparing`, `shipped`, `delivered`, `picked_up`): 배송/수령 상태
  - `tracking_number` (string): 운송장 번호
  - `qr_token` (string, unique): 현장 수령 확인용 토큰
  - `shipping_address_snapshot` (jsonb): 배송 당시의 주소지 스냅샷 (유저 정보 변경 대비)

### `records` (기록)

- **설명:** 대회 종료 후 등록되는 공식 기록.
- **PK:** `id` (bigint)
- **FK:** `user_id` (references `users`), `race_edition_id` (references `race_editions`), `registration_id` (nullable)
- **Fields:**
  - `net_time` (interval/string): 순 기록 (출발선~도착선) - 예: "00:45:30"
  - `gun_time` (interval/string): 공식 기록 (총성~도착선)
  - `rank_overall` (integer): 전체 순위
  - `rank_gender` (integer): 성별 순위
  - `rank_age` (integer): 연령대 순위
  - `splits` (jsonb): 구간 기록 (5km, 10km, 15km 지점 통과 시간 등)
  - `certificate_url` (string): 완주증 이미지 URL
  - `photo_urls` (jsonb_array): 대회 사진 링크 모음
  - `is_verified` (boolean): 관리자 승인 여부 (default: true)

---

## 3. 주요 인덱스 전략 (Indexing Strategy)

- **검색 성능:**
  - `races(status, start_at)`: 진행 중인 최신 대회 조회용 복합 인덱스.
  - `users(email)`, `users(phone_number)`: 회원 조회 및 중복 가입 방지.
- **조인 성능:**
  - `registrations(user_id, race_edition_id)`: 중복 신청 방지 및 마이페이지 조회용.
  - `registrations(merchant_uid)`: 결제 내역 조회용.
  - `records(user_id)`, `records(race_edition_id)` : 기록 조회용.
- **정렬/필터:**
  - `records(net_time)`: 기록 순위 산정용.

---

## 4. 확장 고려사항 (Future Proofing)

1.  **동적 옵션 (Dynamic Options):**
    - `race_editions` 테이블에 `options_schema` (jsonb) 컬럼을 추가하여, 대회마다 다른 추가 질문(예: 주차권 필요 여부, 셔틀버스 탑승지)을 정의하고,
    - `registrations` 테이블에 `user_answers` (jsonb) 컬럼에 그 답변을 저장하는 구조를 고려해볼 수 있습니다.
2.  **다국어 지원 (I18n):**
    - `races` 테이블의 `title`, `description` 등을 별도 `globalize` gem을 이용한 번역 테이블로 분리할 수 있습니다.
