# [2026-02-08] 러닝 대회 플랫폼 개발 일지 및 이관 가이드

## 1. 프로젝트 개요

- **프로젝트명:** Runner's Connect (가칭)
- **목표:** 대규모 트래픽 처리가 가능한 러닝 대회 접수 및 기록 관리 플랫폼 구축
- **기술 스택:** Ruby on Rails 8 (API Mode), PostgreSQL, Docker

## 2. 금일 진행 상황 (Completed)

윈도우 환경에서의 루비 실행 문제로 인해, 소스 코드 작성 위주로 작업을 진행했습니다.

### A. 기획 및 설계

- **[완료] 기능 명세서 (PRD):** 회원가입, 대회 신청, 결제(Simulated), 기록 조회 등 핵심 기능 정의.
- **[완료] 데이터베이스 설계 (ERD):** `users`, `races`, `race_editions`, `registrations`, `records` 테이블 구조 확정.
- **[완료] 화면 설계 (Wireframe):** 메인, 신청, 마이페이지 등 UI 흐름 정의 (`SCREEN_DESIGN.md`).

### B. 백엔드 개발 (Rails)

- **모델(Model) 구현:**
  - `User`: Devise 기반 인증, 프로필 정보(주소, 사이즈 등).
  - `Race`, `RaceEdition`: 대회 정보 및 종목별 정원/가격 관리.
  - `Registration`: 중복 신청 방지, 선착순 마감 체크, 결제 내역(가상) 생성.
  - `Record`: 대회 기록 및 순위 데이터.
- **API 컨트롤러 구현:**
  - 인증: `Api::V1::Auth` (회원가입, 로그인 - JSON 응답).
  - 대회: `Api::V1::RacesController` (목록 및 상세 조회).
  - 신청: `Api::V1::RaceRegistrationsController` (신청 접수, 마이페이지 내역).
- **인프라:**
  - `Dockerfile` 및 `docker-compose.yml` 작성 완료 (PostgreSQL 포함).

## 3. 맥(Mac) 환경에서 이어서 작업하기

윈도우 터미널 멈춤 현상으로 인해 실행(Runtime) 테스트는 하지 못했습니다. 맥으로 코드를 옮긴 후 다음 순서대로 실행해 주세요.

### 옵션 1: Docker로 실행 (추천)

가장 간편한 방법입니다. 로컬에 루비를 설치할 필요가 없습니다.

```bash
# 1. 프로젝트 폴더로 이동
cd backend

# 2. 컨테이너 빌드 및 실행 (DB 생성 및 마이그레이션 자동 수행됨)
docker-compose up --build
```

- 서버 주소: `http://localhost:3000`

### 옵션 2: 로컬 환경에서 실행

맥에 `rbenv` 등을 통해 Ruby 3.2.0 이상이 설치되어 있어야 합니다.

```bash
cd backend

# 1. 의존성 설치
bundle install

# 2. 데이터베이스 생성 및 테이블 적용
rails db:create
rails db:migrate

# 3. 서버 실행
rails s
```

## 4. 바로 다음에 해야 할 작업 (Todo)

1.  **서버 구동 확인:** 위 명령어로 서버가 정상적으로 뜨는지 확인 (`localhost:3000/up` 접속 시 200 OK).
2.  **API 테스트:** Postman 등을 이용해 회원가입 -> 로그인 -> 대회 조회 -> 신청 프로세스 호출 확인.
3.  **결제 연동:** 현재 `test_skip`으로 되어 있는 결제 로직에 포트원(Portone) 연동 추가.
