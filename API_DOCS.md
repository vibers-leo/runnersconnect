# Runner's Connect API Documentation (v1)

Base URL: `https://runnersconnect.vibers.co.kr/api/v1`

## Authentication

JWT 기반 인증. 로그인 시 응답 헤더의 `Authorization` 토큰을 저장하고, 이후 요청에 `Authorization: Bearer <token>` 헤더를 포함합니다.

---

## Auth Endpoints

### POST /api/v1/auth/login

로그인 후 JWT 토큰을 발급합니다.

| 항목 | 내용 |
|------|------|
| Auth | 불필요 |
| Content-Type | application/json |

**Parameters (Body)**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| user[email] | string | O | 이메일 |
| user[password] | string | O | 비밀번호 |

**Response (200)**
```json
{
  "status": { "code": 200, "message": "Logged in successfully." },
  "data": {
    "id": 1,
    "email": "user@example.com",
    "name": "홍길동",
    "role": "user",
    "total_distance": 0,
    "total_races": 0,
    "preferred_size": null
  }
}
```

**Response Header**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

**Error (401)**
```json
{
  "status": { "code": 401, "message": "Could not log in." }
}
```

---

### DELETE /api/v1/auth/logout

로그아웃 후 JWT 토큰을 무효화합니다.

| 항목 | 내용 |
|------|------|
| Auth | Bearer Token 필수 |

**Response (200)**
```json
{
  "status": 200,
  "message": "logged out successfully"
}
```

---

### POST /api/v1/auth/signup

신규 회원가입을 처리합니다.

| 항목 | 내용 |
|------|------|
| Auth | 불필요 |
| Content-Type | application/json |

**Parameters (Body)**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| user[email] | string | O | 이메일 |
| user[password] | string | O | 비밀번호 (6자 이상) |
| user[password_confirmation] | string | O | 비밀번호 확인 |
| user[name] | string | O | 이름 |
| user[phone_number] | string | - | 전화번호 |
| user[birth_date] | date | - | 생년월일 |
| user[gender] | string | - | 성별 |
| user[address_zipcode] | string | - | 우편번호 |
| user[address_basic] | string | - | 기본 주소 |
| user[address_detail] | string | - | 상세 주소 |
| user[preferred_size] | string | - | 선호 사이즈 |

**Response (200)**
```json
{
  "status": { "code": 200, "message": "Signed up successfully." },
  "data": {
    "id": 1,
    "email": "user@example.com",
    "name": "홍길동",
    "role": "user",
    "total_distance": 0,
    "total_races": 0,
    "preferred_size": null
  }
}
```

**Error (422)**
```json
{
  "status": { "message": "User couldn't be created successfully. Email has already been taken" }
}
```

---

## Race Endpoints

### GET /api/v1/races

공개된(open) 대회 목록을 반환합니다. draft 상태의 대회는 제외됩니다.

| 항목 | 내용 |
|------|------|
| Auth | 불필요 |
| Format | JSONAPI::Serializer |

**Response (200)**
```json
{
  "data": [
    {
      "id": "1",
      "type": "race",
      "attributes": {
        "id": 1,
        "title": "서울 벚꽃 마라톤",
        "description": "...",
        "location": "서울 여의도공원",
        "start_at": "2026-05-01T09:00:00.000+09:00",
        "registration_start_at": "2026-03-01T00:00:00.000+09:00",
        "registration_end_at": "2026-04-20T23:59:59.000+09:00",
        "status": "open",
        "thumbnail_url": "/rails/active_storage/blobs/...",
        "organizer_name": "서울마라톤클럽"
      },
      "relationships": {
        "race_editions": {
          "data": [
            { "id": "1", "type": "race_edition" }
          ]
        }
      }
    }
  ],
  "included": [
    {
      "id": "1",
      "type": "race_edition",
      "attributes": {
        "id": 1,
        "name": "10K",
        "distance": 10,
        "price": 30000,
        "capacity": 500,
        "current_count": 123
      }
    }
  ]
}
```

---

### GET /api/v1/races/:id

특정 대회 상세 정보를 반환합니다.

| 항목 | 내용 |
|------|------|
| Auth | 불필요 |
| Format | JSONAPI::Serializer |

**Path Parameters**

| 필드 | 타입 | 설명 |
|------|------|------|
| id | integer | 대회 ID |

**Response (200)** - 위 목록 응답의 단건 형태 (`data`가 단일 객체)

**Error (404)**
```json
{
  "error": "Race not found"
}
```

---

## Registration Endpoints

### POST /api/v1/registrations

대회 참가 신청을 생성합니다. 생성 직후 상태는 `pending`(미결제)입니다.

| 항목 | 내용 |
|------|------|
| Auth | Bearer Token 필수 |
| Content-Type | application/json |

**Parameters (Body)**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| race_edition_id | integer | O | 참가할 종목 ID |
| tshirt_size | string | - | 티셔츠 사이즈 |
| emergency_contact | string | - | 비상 연락처 |
| crew_code | string | - | 크루 코드 (소속 크루 입력) |

**Response (201)**
```json
{
  "message": "Registration created successfully.",
  "data": {
    "data": {
      "id": "1",
      "type": "registration",
      "attributes": {
        "id": 1,
        "status": "pending",
        "bib_number": null,
        "payment_amount": 30000,
        "payment_method": null,
        "merchant_uid": "1711234567_a1b2c3d4",
        "qr_token": "abc123def456...",
        "created_at": "2026-03-25T12:00:00.000+09:00"
      }
    }
  }
}
```

**Error (409) - 중복 신청**
```json
{
  "error": "You have already registered for this race."
}
```

**Error (422) - 정원 초과**
```json
{
  "error": "This race edition is full."
}
```

**Error (422) - 유효하지 않은 크루 코드**
```json
{
  "error": "Invalid crew code."
}
```

---

### GET /api/v1/registrations

현재 로그인 사용자의 참가 신청 목록을 반환합니다.

| 항목 | 내용 |
|------|------|
| Auth | Bearer Token 필수 |
| Format | JSONAPI::Serializer |

**Response (200)**
```json
{
  "data": [
    {
      "id": "1",
      "type": "registration",
      "attributes": {
        "id": 1,
        "status": "paid",
        "bib_number": 42,
        "payment_amount": 30000,
        "payment_method": "card",
        "merchant_uid": "1711234567_a1b2c3d4",
        "qr_token": "abc123def456...",
        "created_at": "2026-03-25T12:00:00.000+09:00"
      },
      "relationships": {
        "race_edition": {
          "data": { "id": "1", "type": "race_edition" }
        }
      }
    }
  ],
  "included": [...]
}
```

---

## Profile Endpoints

### GET /api/v1/profile

현재 로그인 사용자의 프로필 정보를 반환합니다.

| 항목 | 내용 |
|------|------|
| Auth | Bearer Token 필수 |

**Response (200)**
```json
{
  "data": {
    "id": 1,
    "email": "user@example.com",
    "name": "홍길동",
    "role": "user",
    "total_distance": 42.195,
    "total_races": 3,
    "preferred_size": "M"
  }
}
```

---

### PATCH /api/v1/profile

현재 로그인 사용자의 프로필을 수정합니다.

| 항목 | 내용 |
|------|------|
| Auth | Bearer Token 필수 |
| Content-Type | application/json |

**Parameters (Body)**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| user[name] | string | - | 이름 |
| user[phone_number] | string | - | 전화번호 |
| user[birth_date] | date | - | 생년월일 |
| user[gender] | string | - | 성별 |
| user[address_zipcode] | string | - | 우편번호 |
| user[address_basic] | string | - | 기본 주소 |
| user[address_detail] | string | - | 상세 주소 |
| user[preferred_size] | string | - | 선호 사이즈 |
| user[emergency_contact] | string | - | 비상 연락처 |

**Response (200)**
```json
{
  "message": "Profile updated successfully.",
  "data": { ... }
}
```

**Error (422)**
```json
{
  "error": ["Name can't be blank"]
}
```

---

## Community Endpoints

### GET /api/v1/communities

러닝 크루(커뮤니티) 목록을 반환합니다.

| 항목 | 내용 |
|------|------|
| Auth | 불필요 |

**Query Parameters**

| 필드 | 타입 | 설명 |
|------|------|------|
| q | string | 크루명 검색 |
| region | string | 지역 필터 |
| sort | string | 정렬 (popular, featured, recent) |
| page | integer | 페이지 번호 (기본 1) |
| per_page | integer | 페이지당 항목 수 (기본 12) |

**Response (200)**
```json
{
  "communities": [
    {
      "id": 1,
      "name": "서울러닝클럽",
      "slug": "seoul-running-club",
      "short_description": "서울에서 함께 달리는 크루",
      "region": "서울",
      "member_count_estimate": 150,
      "featured": true,
      "leader_name": "김대표",
      "logo_url": "/rails/active_storage/blobs/...",
      "cover_image_url": null,
      "contact_points": [
        {
          "id": 1,
          "platform": "instagram",
          "platform_display": "Instagram",
          "url": "https://instagram.com/...",
          "label": "@seoul_running",
          "primary": true
        }
      ]
    }
  ],
  "meta": {
    "total": 25,
    "page": 1,
    "per_page": 12,
    "total_pages": 3
  }
}
```

---

### GET /api/v1/communities/:slug

특정 크루 상세 정보를 반환합니다.

| 항목 | 내용 |
|------|------|
| Auth | 불필요 |

**Path Parameters**

| 필드 | 타입 | 설명 |
|------|------|------|
| slug | string | 크루 slug (예: seoul-running-club) |

**Response (200)**
```json
{
  "community": {
    "id": 1,
    "name": "서울러닝클럽",
    "slug": "seoul-running-club",
    "short_description": "...",
    "description": "상세 설명...",
    "region": "서울",
    "member_count_estimate": 150,
    "featured": true,
    "leader_name": "김대표",
    "logo_url": "...",
    "cover_image_url": "...",
    "founded_year": 2020,
    "activity_schedule": "매주 토요일 오전 7시",
    "activity_location": "여의도 한강공원",
    "website_url": "https://...",
    "views_count": 1234,
    "published_at": "2026-01-15T00:00:00.000+09:00",
    "activity_photos": ["url1", "url2"],
    "contact_points": [...]
  }
}
```

---

## Race Calendar Endpoints

### GET /api/v1/race_calendar

플랫폼 대회와 외부 대회를 통합한 캘린더 피드를 반환합니다.

| 항목 | 내용 |
|------|------|
| Auth | 불필요 |

**Query Parameters**

| 필드 | 타입 | 설명 |
|------|------|------|
| year | integer | 연도 (기본: 현재 연도) |
| month | integer | 월 (기본: 현재 월) |
| q | string | 대회명 검색 |
| source | string | 소스 필터 (platform, external) |

**Response (200)**
```json
{
  "races": [
    {
      "type": "platform",
      "id": 1,
      "title": "서울 벚꽃 마라톤",
      "date": "2026-04-05",
      "location": "여의도공원",
      "registration_open": true,
      "distances": ["5K", "10K", "하프"]
    },
    {
      "type": "external",
      "id": 10,
      "title": "부산 해운대 마라톤",
      "date": "2026-04-12",
      "location": "해운대 해수욕장",
      "source_name": "마라톤온라인",
      "source_url": "https://...",
      "registration_url": "https://...",
      "distances": ["10K", "풀코스"],
      "fee_info": "10K: 30,000원 / 풀코스: 50,000원"
    }
  ],
  "meta": {
    "year": 2026,
    "month": 4
  }
}
```

---

### GET /api/v1/race_calendar/:id

외부 대회 상세 정보를 반환합니다.

| 항목 | 내용 |
|------|------|
| Auth | 불필요 |

**Response (200)**
```json
{
  "race": {
    "id": 10,
    "title": "부산 해운대 마라톤",
    "description": "...",
    "race_date": "2026-04-12",
    "race_end_date": "2026-04-12",
    "location": "해운대 해수욕장",
    "source_url": "https://...",
    "source_name": "마라톤온라인",
    "registration_url": "https://...",
    "registration_deadline": "2026-04-01",
    "distances": ["10K", "풀코스"],
    "fee_info": "10K: 30,000원",
    "organizer_name": "부산시체육회",
    "image_url": "https://...",
    "status": "active"
  }
}
```

---

## Status Endpoint

### GET /api/v1/status

서버 상태를 확인합니다.

| 항목 | 내용 |
|------|------|
| Auth | 불필요 |

**Response (200)**
```json
{
  "status": "online",
  "message": "Ruby on Rails 백엔드가 정상적으로 작동 중입니다!",
  "time": "2026-03-25T12:00:00.000+09:00"
}
```

---

## Admin Endpoints

### GET /api/v1/admin/dashboard

어드민 대시보드 데이터를 반환합니다.

| 항목 | 내용 |
|------|------|
| Auth | Bearer Token 필수 (admin role) |

---

### POST /api/v1/admin/records/upload

참가자 기록을 업로드합니다.

| 항목 | 내용 |
|------|------|
| Auth | Bearer Token 필수 (admin role) |
| Content-Type | application/json |

**Parameters (Body)**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| registration_id | integer | O | 참가 신청 ID |
| net_time | string | - | 네트 타임 |
| gun_time | string | - | 건 타임 |
| rank_overall | integer | - | 전체 순위 |
| rank_gender | integer | - | 성별 순위 |
| rank_age | integer | - | 연령대 순위 |
| is_verified | boolean | - | 검증 여부 |

**Response (200)**
```json
{
  "message": "Record uploaded successfully.",
  "data": { ... }
}
```

**Error (403)**
```json
{
  "error": "Forbidden"
}
```

---

## Common Error Responses

### 401 Unauthorized
인증이 필요한 엔드포인트에 토큰 없이 접근한 경우.

### 403 Forbidden
권한이 없는 사용자가 관리자 API에 접근한 경우.

### 404 Not Found
요청한 리소스가 존재하지 않는 경우.

### 422 Unprocessable Entity
유효성 검사 실패 또는 비즈니스 로직 오류.

---

## Notes

- 모든 날짜/시간은 ISO 8601 형식 (KST, +09:00)
- Race, Registration 응답은 [JSONAPI::Serializer](https://github.com/jsonapi-serializer/jsonapi-serializer) 형식
- Community, Race Calendar 응답은 커스텀 JSON 형식
- JWT 토큰은 응답 헤더 `Authorization`에 포함되며, `Bearer` prefix 사용
- 페이지네이션은 `page`, `per_page` 쿼리 파라미터로 제어 (Community API)
