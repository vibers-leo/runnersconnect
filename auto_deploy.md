# 배포 자동화 및 검증 가이드

## 배포 흐름

```
git push origin main
  → GitHub Actions (Deploy to NCP)
  → ssh wero: docker compose up -d --build
  → 검증: check-deploy.sh
```

## 배포 후 반드시 실행할 검증 명령

```bash
# 1. GitHub Actions 상태 확인
gh run list --limit 3

# 2. NCP 컨테이너 + HTTP 상태 확인
ssh wero "bash /root/check-deploy.sh runnersconnect-api https://runnersconnect.vibers.co.kr"
```

**결과 해석:**
- `DEPLOY OK` → 정상. 사용자에게 성공 보고
- `http=502` → 컨테이너 크래시. 로그 확인 후 조치
- `container=stopped` → 컨테이너 다운. `docker compose up -d` 재실행

## 502 에러 시 대응 절차

1. 로그 확인
```bash
ssh wero "docker logs runnersconnect-api --tail=30"
```

2. 환경변수 문제 → docker-compose.yml에 직접 명시 (DEVISE_JWT_SECRET_KEY 등)
3. 컨테이너 재생성 (restart 아닌 up -d 사용)
```bash
ssh wero "cd /root/projects/runnersconnect/backend && docker compose up -d runnersconnect-api"
```

## 알려진 이슈

| 증상 | 원인 | 해결 |
|------|------|------|
| `DEVISE_JWT_SECRET_KEY 환경변수가 설정되지 않았습니다` | docker-compose.yml에 env 미지정 | docker-compose.yml environment 섹션에 직접 명시 |
| `docker compose restart`로 env 미적용 | restart는 환경변수 재로드 안 함 | `docker compose up -d`로 컨테이너 재생성 |

## 프로젝트 정보

| 항목 | 값 |
|------|----|
| 컨테이너명 | runnersconnect-api |
| 포트 | 4070 |
| 도메인 | runnersconnect.vibers.co.kr |
| .env 위치 | /root/projects/runnersconnect/.env |
| compose 위치 | /root/projects/runnersconnect/backend/docker-compose.yml |
