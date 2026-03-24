---
name: 프로젝트 현재 상태
description: Runner's Connect 인프라, 배포 구조, 주요 설정
type: project
---

## Runner's Connect 프로젝트 상태 (2026-03-24 기준)

### 인프라
- **서버**: NCP(네이버 클라우드 플랫폼) / IP: 49.50.138.93
- **경로**: `/root/projects/runnersconnect/backend`
- **이전 서버**: Fly.io → 삭제 완료 (runnersconnect-backend, runnersconnect-db 모두 삭제)

### Docker 구성
- `runnersconnect-api`: port 4070:8000 (내부 8000, 외부 4070)
- `runnersconnect-db`: PostgreSQL 16-alpine (내부 네트워크만)
- 네트워크: `npm_default` (외부, Nginx Proxy Manager와 통신) + `internal`
- SSL: Cloudflare에서 직접 처리

**Why:** Fly.io 비용($20/월) 대비 NCP가 더 저렴하고 안정적. 앱스토어 출시 전 서버 이전 완료.

### 자동 배포
- GitHub Actions (`webfactory/ssh-agent@v0.9.0`)
- `git push origin main` → 자동으로 NCP 서버 배포
- **GitHub Secrets**: NCP_HOST, NCP_USER, NCP_SSH_KEY
- **NCP_SSH_KEY**: 서버의 `~/.ssh/deploy_key` 비밀키 (공개키 `github-actions-deploy`가 authorized_keys에 등록됨)

### DB 접속 정보
- 서버 `/root/projects/runnersconnect/backend/.env` 파일에 저장됨
- RAILS_MASTER_KEY: `backend/config/master.key` 파일에 저장됨 (gitignore)

### GitHub 레포
- https://github.com/vibers-leo/runnersconnect (현재 활성)
- 구 레포: juuuno-coder/runnersconnect (리다이렉트됨)

### 최근 작업
- 크롤링 시스템 추가 (외부 대회 정보 수집)
- 커뮤니티 프로필, 레이스 캘린더 추가
- Fly.io 삭제 후 NCP Docker 배포 완료
- GitHub Actions 자동배포 설정 완료
