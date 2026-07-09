# AGENTS.md

## Mission

Maintain this repository as a stable, reproducible R package for fixed-item
parameter calibration and test linking.

## Non-negotiable guardrails

1. Preserve historical numerical behavior in `R/aFIPC.R` unless there is
   explicit regression evidence and maintainer intent to change behavior.
2. Treat CI/security/docs hygiene as first-class maintenance work.
3. Keep changes minimal and auditable; prefer additive guardrails over broad
   refactoring.

## Required maintenance checks

- Keep `.github/workflows/` green and action SHAs pinned.
- Keep `.github/dependabot.yml` active for GitHub Actions updates.
- Keep `ARCHITECTURE.md` up to date when structure changes.
- Keep README accurate for local verification commands.

## Editing priorities

1. Safety and reproducibility
2. CI reliability
3. Documentation clarity
4. Feature changes

## High-risk areas

- `R/aFIPC.R` contains long legacy logic with interactive prompts.
- Any changes around calibration/linking constraints can alter scientific output.

## Preferred change strategy

- Add tests/fixtures first when behavior changes are required.
- Isolate operational fixes (workflow/docs/dependency policy) from algorithmic
  edits.
- Document assumptions and risk in commit/PR summaries.

---

<!-- markdownlint-disable MD004 MD013 MD036 -->

## [Figma] 디자인 시스템 명칭 사용을 위한 최소 구성요소 및 작업 기준 정의

### 배경

KRDS는 디자인 시스템을 단순한 화면 시안이나 UI 컴포넌트 묶음이 아니라, **편의성·일관성·접근성·사용성 보장**과 **표준화된 UX/UI 제공**을 목적으로 하는 체계로 설명한다. 또한 KRDS 디자인 시스템은 "규칙, 원칙, 컴포넌트, 스타일 가이드, 패턴 및 도구들의 모음"으로 정의되어 있으므로, Figma 파일에 일부 컴포넌트만 존재하는 상태를 곧바로 "디자인 시스템"이라고 부르는 것은 부정확하다. ([KRDS][1])

따라서 본 문서에서는 Figma 작업물이 **디자인 시스템**이라는 명칭을 사용하기 위해 기본적으로 갖춰야 할 사항을 아래와 같이 정의한다.

---

### 디자인 시스템이라고 부르기 위한 기본 요건

#### 1. 목적, 범위, 적용 대상이 정의되어 있어야 한다

디자인 시스템은 "어떤 서비스군에 적용되는가", "웹/모바일/앱 중 어디까지 포함하는가", "필수 준수 영역과 기관·서비스별 확장 가능 영역은 무엇인가"가 먼저 정의되어야 한다. KRDS도 표준형 스타일과 확장형 스타일을 구분하고, 표준형은 모든 스타일 요소와 규칙을 필수적으로 준수하도록 하며, 확장형은 기본 규칙을 지키면서 기관 특성을 반영할 수 있도록 설명한다. ([KRDS][2])

**Figma 작업 기준**

* 파일 첫 화면 또는 README 페이지에 적용 범위, 대상 플랫폼, 적용 원칙을 명시한다.
* "필수 사용", "권장 사용", "확장 가능", "사용 금지" 항목을 구분한다.
* 기관/브랜드별 변형이 허용되는 항목과 허용되지 않는 항목을 분리한다.

---

#### 2. 디자인 스타일, 즉 Foundation이 체계화되어 있어야 한다

KRDS의 디자인 스타일은 색상, 타이포그래피, 형태, 레이아웃, 아이콘, 엘리베이션으로 구성되며, 이 항목들을 통해 일관성, 접근성, 효율적인 디자인 작업을 유지한다고 설명한다. ([KRDS][2])

따라서 최소한 다음 항목이 있어야 한다.

| 구분 | 있어야 하는 내용 |
| --- | --- |
| 색상 | 팔레트, 주요 색상, 시스템 색상, 강조 색상, 상태 색상, 대비 기준, 사용 가이드 |
| 타이포그래피 | 서체, 굵기, 크기, 줄 간격, 글자 스케일, 계층 구조, 접근성 기준 |
| 형태 | radius 값, 형태 원칙, 적용 기준 |
| 레이아웃 | 그리드, 브레이크포인트, 콘텐츠 영역, 간격 체계, 반응형 기준 |
| 아이콘 | 시스템 아이콘, 크기, 키라인, 두께, 색상, 사용 기준 |
| 엘리베이션 | 그림자, 경계선, 딤드 처리, 레이어 위계, 적용 기준 |

**Figma 작업 기준**

* 임의 색상, 임의 폰트 크기, 임의 간격을 직접 입력하지 않는다.
* 색상, 간격, radius, typography는 Variables 또는 Styles로 관리한다.
* 반응형 레이아웃과 화면 크기별 기준을 별도 페이지로 정리한다.
* 접근성 검토가 필요한 색상 대비, 글자 크기, 줄 간격을 명시한다.

---

#### 3. 디자인 토큰 체계가 있어야 한다

KRDS는 디자인 토큰을 색상, 글자, 간격, 그림자 등 반복적으로 사용되는 디자인 속성을 변수로 정의한 코드라고 설명하며, 이를 통해 디자인 시스템 전반의 일관성을 유지한다고 설명한다. 또한 토큰은 primitive token, semantic token, component token의 세 단계로 구분된다. ([KRDS][3])

**필수 토큰 구조**

1. **Primitive Token** — 원시값. 예: `primary-50`, `gray-10`, `space-8`, `radius-4`.
2. **Semantic Token** — 의미 기반 토큰. 예: `color-background-primary`, `color-text-disabled`, `space-card-padding`.
3. **Component Token** — 특정 컴포넌트에 직접 적용되는 토큰. 예: `button-primary-background-color`, `input-border-radius`.

**Figma 작업 기준**

* 컴포넌트에 원시 색상값을 직접 적용하지 않는다.
* Figma에서는 가능한 한 semantic token을 사용한다.
* KRDS 방식처럼 디자인 툴과 코드의 역할을 분리할 경우, Figma에서는 semantic token까지만 관리하고 component token은 코드에서 관리하는 기준을 명확히 둔다. ([KRDS][3])
* Figma Variables의 mode를 활용하여 기본 모드, 고대비/선명한 화면 모드, 디바이스 크기별 반응형 모드를 관리한다. ([Figma 도움말 센터][4])

---

#### 4. 컴포넌트 라이브러리가 있어야 한다

KRDS는 컴포넌트를 "사용자 인터페이스의 가장 작은 단위로 과업에 상관없이 일관성 있게 사용되는 공통 요소"라고 설명한다. 각 컴포넌트는 특성, 상태, 역할에 따른 유형, 사용성, 접근성, 상호작용 가이드라인, 플랫폼 고려 사항을 포함해야 한다. ([KRDS][5])

**Figma 작업 기준** — 각 컴포넌트에는 최소한 다음이 있어야 한다.

* 컴포넌트명 / 용도 / 사용해야 하는 경우 / 사용하지 말아야 하는 경우
* 구조/anatomy / variant / state (default, hover, focus, active, pressed, disabled, error 등)
* size / responsive behavior / interaction / keyboard·focus 기준
* 접근성 기준 / 연결되는 개발 컴포넌트명 / 관련 token / 변경 이력

---

#### 5. Variant, State, Property 체계가 있어야 한다

컴포넌트가 단순히 시각적 그룹으로만 존재하면 재사용 가능한 시스템 요소라고 보기 어렵다. ([Figma 도움말 센터][6])

**Figma 작업 기준**

* `Button / Type=Primary / Size=Large / State=Default / Icon=True`처럼 구조화한다.
* 불필요하게 모든 조합을 별도 컴포넌트로 만들지 않는다.
* Boolean, instance swap, text, variant, slot property를 적절히 사용한다.
* hover, pressed, selected, expanded 같은 상호작용 상태는 interactive component로 정의한다. ([Figma 도움말 센터][7])

---

#### 6. 기본 패턴이 있어야 한다

KRDS는 기본 패턴을 "컴포넌트 요소들이 조합되어 핵심 과업을 수행하는 데 반복적으로 함께 사용되는 사용자 인터페이스 집합"이라고 설명한다. ([KRDS][8])

**기본 패턴 예시**: 개인 식별 정보 입력, 도움, 동의, 목록 탐색, 사용자 피드백, 상세 정보 확인, 오류, 입력폼, 첨부파일, 필터링·정렬, 확인

**Figma 작업 기준**

* 컴포넌트와 패턴을 같은 수준에서 섞지 않는다 ("텍스트 입력 필드"는 컴포넌트, "회원정보 입력폼"은 패턴).
* 패턴 페이지에는 실제 조합 예시, 사용 흐름, 접근성 주의사항, 금지 사례를 포함한다.

---

#### 7. 서비스 패턴 또는 사용자 여정 기반 템플릿이 있어야 한다

KRDS는 서비스 패턴을 "디지털 정부서비스에서 제공하는 핵심 과업에 대한 사용자 여정 기반의 사용자 경험 설계 가이드"라고 설명한다. ([KRDS][9])

**서비스 패턴 예시**: 방문, 검색, 로그인, 신청, 정책 정보 확인

**Figma 작업 기준**

* 주요 사용자 여정별 flow를 제공한다.
* 시작점, 중간 상태, 오류 상태, 완료 상태까지 포함한다.
* 핵심 flow는 prototype으로 연결한다.
* "Do / Better / Best" 또는 "필수 / 권장 / 우수" 수준을 구분한다.

---

#### 8. 접근성 및 디지털 포용 기준이 포함되어야 한다

KRDS는 색상, 타이포그래피, 형태, 아이콘, 레이아웃, 엘리베이션 등 주요 접근성 요소를 설계 단계에서 점검해야 한다고 설명한다. ([KRDS][2])

**Figma 작업 기준**

* 색상 대비 기준을 token 또는 style 설명에 포함한다.
* focus 상태를 누락하지 않는다.
* 키보드 탐색 순서, 스크린리더 레이블, 숨김 텍스트 필요 여부를 명시한다.
* 텍스트 확대, 고대비 모드, 모바일 환경을 고려한다.
* 접근성은 "개발 후 검수 항목"이 아니라 컴포넌트 설계 단계에서 포함해야 한다.

---

#### 9. 문서화와 사용 가이드가 있어야 한다

KRDS는 웹사이트를 디자인 시스템의 사용 방법, 목적, 규칙, 코드 샘플 등을 문서화하는 중심 허브로 설명한다. ([KRDS][1])

**Figma 작업 기준**

* 컴포넌트에 description을 작성한다.
* 외부 문서, Storybook, GitHub, 개발 컴포넌트 링크를 연결한다.
* 라이브러리 업데이트 시 변경 설명을 남긴다.
* deprecated 컴포넌트와 대체 컴포넌트를 명시한다.
* "어떻게 생겼는가"뿐 아니라 "언제, 왜, 어떻게 써야 하는가"를 문서화한다.

---

#### 10. 코드 구현체 또는 개발 연계 기준이 있어야 한다

KRDS는 디자인 라이브러리, 디자인 토큰, HTML Component Kit를 연동하는 작업이 디자인을 효율적으로 관리하고 일관성을 유지하는 핵심 과정이라고 설명한다. ([KRDS][1])

**Figma 작업 기준**

* Figma 컴포넌트명과 개발 컴포넌트명을 매핑한다.
* token 이름이 코드 변수명과 연결되어야 한다.
* CSS variable, JSON token, Storybook, 패키지 버전 등을 함께 관리한다.
* "Figma에는 있는데 개발에는 없음", "개발에는 있는데 Figma에는 없음" 상태를 지속적으로 정리한다.

---

### Figma 작업 시 주의사항

다음 상태라면 **디자인 시스템**이라고 부르지 말고, "UI Kit", "Figma Library", "화면 템플릿", "컴포넌트 초안" 등으로 명칭을 낮춰야 한다.

* 색상과 폰트가 임의 값으로 적용되어 있다.
* token/variable 없이 컴포넌트마다 직접 스타일을 지정한다.
* variant와 state가 정의되어 있지 않다.
* hover, focus, disabled, error 상태가 누락되어 있다.
* 접근성 기준이 없다.
* 컴포넌트 사용 기준이 없다.
* 패턴과 사용자 여정이 없다.
* 개발 컴포넌트와 매핑되지 않는다.
* 변경 이력과 버전 관리가 없다.
* 문서화 없이 화면 예시만 존재한다.

---

### 완료 기준 Definition of Done

아래 항목을 충족해야 "디자인 시스템"으로 명명할 수 있다.

* [ ] 목적, 범위, 적용 대상, 적용 수준이 문서화되어 있다.
* [ ] 색상, 타이포그래피, 형태, 레이아웃, 아이콘, 엘리베이션 기준이 있다.
* [ ] primitive / semantic / component token 체계가 있다.
* [ ] Figma Variables 또는 Styles로 주요 foundation이 관리된다.
* [ ] 주요 컴포넌트가 variant, state, property 구조로 정리되어 있다.
* [ ] 각 컴포넌트에 사용 기준, 접근성 기준, 상호작용 기준이 있다.
* [ ] 반복 과업을 위한 기본 패턴이 있다.
* [ ] 핵심 사용자 여정 기반의 서비스 패턴 또는 prototype이 있다.
* [ ] Figma 컴포넌트와 개발 컴포넌트가 매핑되어 있다.
* [ ] 문서, 변경 이력, 버전 관리, deprecated 정책이 있다.
* [ ] 접근성 검토 기준이 설계 단계에 포함되어 있다.

---

### 결론

본 프로젝트에서 "디자인 시스템"이라는 명칭을 사용하려면, Figma 파일은 단순한 시안 저장소가 아니라 **Foundation, Token, Component, Pattern, Service Flow, Accessibility, Documentation, Code Mapping, Versioning**을 포함하는 운영 가능한 체계여야 한다. KRDS 기준에 비추어 보면, 일부 스타일과 컴포넌트만 존재하는 상태는 디자인 시스템이 아니라 **UI Kit 또는 디자인 라이브러리 초안**으로 보는 것이 타당하다.

[1]: https://www.krds.go.kr/html/site/utility/utility_01.html "KRDS 소개 | KRDS 소개 - KRDS"
[2]: https://www.krds.go.kr/html/site/style/style_01.html "디자인 스타일 소개 - KRDS"
[3]: https://www.krds.go.kr/html/site/style/style_07.html "디자인 토큰(Design Token) | 스타일 가이드 - KRDS"
[4]: https://help.figma.com/hc/en-us/articles/15339657135383-Guide-to-variables-in-Figma "Guide to variables in Figma"
[5]: https://www.krds.go.kr/html/site/component/component_summary.html "공식 배너 (Masthead) | 컴포넌트 - KRDS"
[6]: https://help.figma.com/hc/en-us/articles/360056440594-Create-and-use-variants "Create and use variants"
[7]: https://help.figma.com/hc/en-us/articles/360061175334-Create-interactive-components-with-variants "Create interactive components with variants"
[8]: https://www.krds.go.kr/html/site/global/global_summary.html "기본 패턴 소개 | 컴포넌트 - KRDS"
[9]: https://www.krds.go.kr/html/site/service/service_summary.html "서비스 패턴 소개 | 컴포넌트 - KRDS"

<!-- markdownlint-enable MD004 MD013 MD036 -->
