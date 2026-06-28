-- ============================================================
-- 회원 상담 시스템 — Supabase 스키마
-- 실행 위치: Supabase Dashboard → SQL Editor → New query
-- ============================================================

-- 1. members (회원)
CREATE TABLE members (
  id           SERIAL PRIMARY KEY,
  phone        TEXT NOT NULL UNIQUE,
  name         TEXT NOT NULL,
  join_date    DATE DEFAULT CURRENT_DATE,
  is_admin     BOOLEAN DEFAULT FALSE,
  memo         TEXT,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- 2. fee_payments (회비)
CREATE TABLE fee_payments (
  id           SERIAL PRIMARY KEY,
  member_id    INTEGER NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  period       TEXT NOT NULL,
  amount       NUMERIC NOT NULL,
  paid_amount  NUMERIC DEFAULT 0,
  paid_date    DATE,
  status       TEXT NOT NULL CHECK (status IN ('미납','부분납','완납')),
  note         TEXT,
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (member_id, period)
);
CREATE INDEX idx_fee_payments_member ON fee_payments(member_id);

-- 3. qa_threads (상담 스레드)
CREATE TABLE qa_threads (
  id              SERIAL PRIMARY KEY,
  member_id       INTEGER NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  subject         TEXT NOT NULL,
  related_period  TEXT,
  status          TEXT NOT NULL DEFAULT '대기' CHECK (status IN ('대기','답변완료','종료')),
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_qa_threads_member ON qa_threads(member_id);

-- 4. qa_messages (상담 메시지)
CREATE TABLE qa_messages (
  id           SERIAL PRIMARY KEY,
  thread_id    INTEGER NOT NULL REFERENCES qa_threads(id) ON DELETE CASCADE,
  sender_type  TEXT NOT NULL CHECK (sender_type IN ('member','admin')),
  sender_name  TEXT NOT NULL,
  body         TEXT NOT NULL,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_qa_messages_thread ON qa_messages(thread_id);

-- 5. app_settings (앱 설정)
CREATE TABLE app_settings (
  key          TEXT PRIMARY KEY,
  value        TEXT NOT NULL,
  updated_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- RLS (Row Level Security) — anon key로 모든 작업 허용
-- 실제 권한 통제는 프론트엔드 로그인 로직에서 수행
-- (휴대폰번호만으로 로그인하는 단순 구조이므로 DB 레벨 격리 없음)
-- ============================================================
ALTER TABLE members        ENABLE ROW LEVEL SECURITY;
ALTER TABLE fee_payments   ENABLE ROW LEVEL SECURITY;
ALTER TABLE qa_threads     ENABLE ROW LEVEL SECURITY;
ALTER TABLE qa_messages    ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_settings   ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon all members"        ON members        FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon all fee_payments"   ON fee_payments   FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon all qa_threads"     ON qa_threads     FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon all qa_messages"    ON qa_messages    FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon all app_settings"   ON app_settings   FOR ALL TO anon USING (true) WITH CHECK (true);
