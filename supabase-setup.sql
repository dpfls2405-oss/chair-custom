-- =============================================
-- Sidiz Chair Customizer — Supabase Setup
-- =============================================
-- Supabase Dashboard → SQL Editor에서 이 파일 전체를 실행하세요

-- 1. 주문 테이블 생성
CREATE TABLE IF NOT EXISTS orders (
  id BIGSERIAL PRIMARY KEY,
  
  -- 모델 정보
  model TEXT NOT NULL,                    -- T80, T50, T40
  grade TEXT,                             -- Premium, Standard, Basic
  
  -- 커스터마이징 데이터
  colors JSONB NOT NULL,                  -- 부품별 색상 HEX 코드
  removed_parts JSONB DEFAULT '[]',       -- 삭제된 부품 목록
  aluminum_parts JSONB DEFAULT '[]',      -- 폴리쉬 알루미늄 적용 부품
  fabric_code TEXT,                       -- Sidiz 패브릭 코드 (예: 834C)
  
  -- 전체 스펙 JSON
  spec_json JSONB,                        -- buildJSON() 결과 전체
  
  -- AI 생성 이미지 (base64)
  ai_image TEXT,                          -- Ctrl+V로 붙여넣은 이미지 데이터
  
  -- 주문 관리
  status TEXT DEFAULT 'pending',          -- pending / confirmed / production / completed / cancelled
  note TEXT,                              -- 메모
  ordered_by TEXT,                        -- 주문자 이름/ID (선택)
  
  -- 타임스탬프
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. RLS (Row Level Security) 활성화
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- 3. 모든 사용자 읽기/쓰기 허용 (공유 주문 시스템)
-- 필요에 따라 더 제한적인 정책으로 변경 가능
CREATE POLICY "Allow public read" ON orders
  FOR SELECT USING (true);

CREATE POLICY "Allow public insert" ON orders
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public update" ON orders
  FOR UPDATE USING (true) WITH CHECK (true);

-- 4. 인덱스 (검색 성능 향상)
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_model ON orders(model);

-- 5. updated_at 자동 갱신 함수
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- =============================================
-- 설정 완료! 앱 하단에서 Supabase URL과 anon key를 입력하세요
-- =============================================
