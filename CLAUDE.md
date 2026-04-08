# 러너스커넥트 (RunnersConnect)

## 공통 지침
- Rails 공통 규칙: `dev/rails/CLAUDE.md` 참조
- NCP Docker 배포: 포트 4070, 도메인 runnersconnect.vibers.co.kr

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
