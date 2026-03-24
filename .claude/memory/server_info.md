---
name: 서버 접속 및 배포 정보
description: NCP 서버 접속 정보 및 기타 서비스
type: reference
---

## NCP 서버 (공통)
- IP: 49.50.138.93
- 유저: root
- 프로젝트 경로: /root/projects/

## SSH 접속 (로컬에서)
```bash
ssh root@49.50.138.93  # 비밀번호 접속 (NCP 콘솔에서 확인)
```

## 현재 운영 중인 서비스 (NCP)
- runnersconnect: port 4070 → `/root/projects/runnersconnect/backend`
- matecheck: port 4010 → `/root/projects/matecheck`
- 공통 네트워크: npm_default (Nginx Proxy Manager)

## Fly.io 계정
- 이메일: nerounni@gmail.com
- 남은 앱: dlab-website, haebojago, matecheck-backend-api, matecheck-db, wayo
- runnersconnect 관련 앱은 삭제 완료

## GitHub
- 레포: https://github.com/vibers-leo/runnersconnect
- Actions secrets: NCP_HOST, NCP_USER, NCP_SSH_KEY 등록됨
