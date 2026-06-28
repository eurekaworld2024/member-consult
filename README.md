# 회원 상담 시스템

Supabase + Vercel 기반 정적 사이트

## 구조
- `index.html` — 메인 (회원/관리자 선택)
- `member.html` — 회원 상담실
- `admin.html` — 관리자 콘솔
- `config.js` — Supabase URL/key 설정
- `sql/01_schema.sql` — DB 테이블 생성
- `sql/02_data.sql` — 초기 데이터 import

## 배포
1. Supabase SQL Editor에서 `01_schema.sql` → `02_data.sql` 실행
2. GitHub 저장소에 푸시
3. Vercel에서 Import → 자동 배포

## 로그인 정보 (예시)
- 관리자: `01000000000`
- 회원: `01012345678` (김민수), `01045678901` (최서연) 등
