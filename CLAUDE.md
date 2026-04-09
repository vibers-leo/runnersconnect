# 러너스커넥트 (RunnersConnect)

## 공통 지침
- Rails 공통 규칙: `dev/rails/CLAUDE.md` 참조
- NCP Docker 배포: 포트 4070, 도메인 runnersconnect.vibers.co.kr

## 배포 후 필수 검증 (MANDATORY)

**git push 또는 배포 작업 완료 후 반드시 아래 순서로 검증하고 결과를 사용자에게 보고한다.**

```bash
# Step 1: GitHub Actions 결과 확인
gh run list --limit 3

# Step 2: NCP 서버 컨테이너 + HTTP 상태 확인
ssh wero "bash /root/check-deploy.sh runnersconnect-api https://runnersconnect.vibers.co.kr"
```

**보고 형식:**
- ✅ DEPLOY OK → "배포 성공: runnersconnect.vibers.co.kr 정상 응답 확인"
- ❌ FAIL → "배포 실패: [에러 원인] → [즉시 조치 시작]"

**502 에러 즉시 조치:**
1. `ssh wero "docker logs runnersconnect-api --tail=30"` 로그 확인
2. 환경변수 누락이면 docker-compose.yml에 직접 명시
3. `ssh wero "cd /root/projects/runnersconnect/backend && docker compose up -d runnersconnect-api"` 재생성
4. 상세 절차: `auto_deploy.md` 참조

## 세션로그 기록 (필수)
- 모든 개발 대화의 주요 내용을 `session-logs/` 폴더에 기록할 것
- 파일명: `YYYY-MM-DD_한글제목.md` / 내용: 한글
- 세션 종료 시, 마일스톤 달성 시, **컨텍스트 압축 전**에 반드시 저장
- 상세 포맷은 상위 CLAUDE.md 참조

## Vibers 공통 스킬 연동

| 작업 | 공통 스킬 | 비고 |
|------|----------|------|
| PDF 생성 (완주증명서·영수증) | `/web-to-pdf` | `app/services/pdf/` 원본 패턴 |
| 서버·Docker 점검 | `/vibers-admin` | NCP 포트 4070 |
| 랜딩 디자인 | `/vibers-design` | BOLD_DARK 테마 권장 |

**이 프로젝트의 `app/services/pdf/`는 Rails HTML→PDF 패턴의 원본이다.**
- `race_certificate_service.rb` → 완주증명서 (wicked_pdf 기반)
- `settlement_receipt_service.rb` → 정산영수증
- PDF 생성 관련 개선사항은 `/web-to-pdf` 공통 스킬의 Rails 섹션과 동기화할 것
