# 🪑 Sidiz Chair Customizer — Order System

Sidiz T80/T50/T40 의자 커스터마이징 + AI 이미지 생성 + Supabase 주문 관리 시스템

## 🚀 Vercel 배포 방법

### 1단계: GitHub 저장소 생성
```bash
# 이 폴더를 GitHub에 올리기
cd sidiz-deploy
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/sidiz-customizer.git
git push -u origin main
```

### 2단계: Vercel 배포
1. [vercel.com](https://vercel.com) 접속 → GitHub 로그인
2. "New Project" → 위에서 만든 저장소 선택
3. Framework: "Other" 선택
4. "Deploy" 클릭
5. 끝! `https://sidiz-customizer.vercel.app` 같은 URL이 생성됨

### 3단계: 업데이트 방법
```bash
# 파일 수정 후
git add .
git commit -m "Update"
git push
# Vercel이 자동으로 재배포됨
```

---

## 💾 Supabase 설정

### 테이블 생성 SQL
Supabase Dashboard → SQL Editor에서 실행:

```sql
CREATE TABLE orders (
  id BIGSERIAL PRIMARY KEY,
  model TEXT NOT NULL,
  grade TEXT,
  colors JSONB NOT NULL,
  removed_parts JSONB DEFAULT '[]',
  aluminum_parts JSONB DEFAULT '[]',
  fabric_code TEXT,
  spec_json JSONB,
  ai_image TEXT,
  status TEXT DEFAULT 'pending',
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS (Row Level Security) 설정
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- 모든 사용자가 읽기/쓰기 가능 (공유 주문 시스템)
CREATE POLICY "Allow all access" ON orders
  FOR ALL USING (true) WITH CHECK (true);

-- 인덱스
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_model ON orders(model);
```

### 앱에서 Supabase 연결
1. Supabase Dashboard → Settings → API
2. **Project URL** 복사 → 앱 하단 "Supabase URL" 입력
3. **anon public key** 복사 → 앱 하단 "anon key" 입력
4. "연결" 버튼 클릭

---

## 🎨 AI Studio 이미지 생성 방법

1. 앱에서 색상/부품 편집
2. "📋 프롬프트 복사" 클릭
3. "🚀 AI Studio 열기" 클릭
4. **"Image Generation" 카드** 선택 (중요!)
5. "Grounding with Google Search" 태그 제거
6. 📎 원본 의자 이미지 첨부 (필수!)
7. 프롬프트 붙여넣기 → Ctrl+Enter
8. 생성된 이미지를 앱에서 Ctrl+V로 붙여넣기

> AI Studio 웹 UI는 하루 500~1,000장 무료 (신용카드 불필요)

---

## 📁 파일 구조

```
sidiz-deploy/
├── public/
│   └── index.html      # 메인 앱 (모든 코드 포함)
├── vercel.json          # Vercel 설정
├── package.json         # 프로젝트 정보
├── supabase-setup.sql   # Supabase 테이블 생성 SQL
└── README.md            # 이 파일
```

---

## 🔧 주요 기능

- **모델 선택**: T80 Premium / T50 Standard / T40 Basic
- **컬러 편집**: 8개 부품 개별 색상 변경 + 컬러 피커 + 프리셋
- **Sidiz 패브릭 컬러칩**: 공식 36색 팔레트
- **Polished Aluminum 마감**: 프레임/실린더/베이스 적용
- **부품 삭제**: 헤드레스트/팔걸이/럼버서포트 토글
- **스포이드**: 레퍼런스 이미지에서 클릭으로 색상 추출
- **AI 이미지 생성**: Google AI Studio 연동 (프롬프트 자동 생성)
- **BOM 주문 사양서**: 실시간 주문 스펙 요약
- **Supabase 주문 관리**: 저장/불러오기/상태 관리
- **JSON 내보내기**: 전체 커스텀 스펙 파일

---

## 💰 비용

| 항목 | 비용 |
|------|------|
| Vercel 호스팅 | 무료 (Hobby Plan) |
| Supabase DB | 무료 (500MB) |
| AI Studio 이미지 | 무료 (하루 500~1000장) |
| **총 비용** | **$0/월** |
