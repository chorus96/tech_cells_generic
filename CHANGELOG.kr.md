# 변경 이력

이 프로젝트의 주요 변경 사항은 모두 이 파일에 기록됩니다.

파일 형식은 [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)를 따르며,
이 프로젝트는 [유의적 버전](http://semver.org/spec/v2.0.0.html)을 준수합니다.

## 미출시 (Unreleased)
### 변경
- 코드 스타일에 맞지 않는 Verilator 린터 경고 억제 처리

## 0.2.13 - 2023-09-19
### 수정
- `tc_sram_xilinx`: 바이트 인에이블(be) 할당 오류 수정

## 0.2.12 - 2023-08-12
### 변경
- `tc_sram_xilinx`: `ByteWidth != 8` 지원 추가

## 0.2.11 - 2022-12-12
### 추가
- `tc_clk_or2`: 균형 잡힌 클럭 OR 게이트를 위한 새로운 범용 기술 셀 추가
- `tc_clk_mux2`: `tc_clk_mux2` 셀 오용에 대한 경고 문구 추가

## 0.2.10 - 2022-11-20
### 추가
- `tc_sram_impl`: 구현체별 키 및 IO를 갖는 `tc_sram` 래퍼 추가

### 변경
- `tc_sram`: 시뮬레이션 성능 개선

### 수정
- `tc_clk_xilinx`: `tc_clk_gating` 인터페이스와 일치하도록 `IS_FUNCTIONAL` 파라미터 추가

## 0.2.9 - 2022-03-17
### 변경
- `tc_clk_gating` 셀에 선택적 `IS_FUNCTIONAL` 플래그 추가. 기능적으로 *필수가 아닌* 게이팅 셀을 표시할 수 있습니다.

## 0.2.8
*건너뜀*

## 0.2.7
*건너뜀*

## 0.2.6 - 2021-10-04
### 추가
- `pad_functional_xilinx` 추가

### 수정
- Bender 타겟 설정 수정

### 제거
- 래퍼로 대체된 구형 Xilinx `clk_cell` 삭제

## 0.2.5
*건너뜀*

## 0.2.4 - 2021-02-04
- `deprecated/pulp_clk_cells_xilinx.sv`를 `Bender.yml`에 추가

## 0.2.3 - 2021-01-28
### 수정
- `tc_sram_xilinx`: `SimInit` 파라미터에서 미지원 `string` 타입 제거
- `IPApproX`: IPApproX로 올바르게 컴파일되도록 `src_files.yml`에 `tc_sram` 추가

## 0.2.2 - 2020-11-11
### 수정
- `Bender`: `udma_core`와의 호환성을 위해 deprecated `pulp_clock_gating_async` 추가

## 0.2.1 - 2020-06-23
### 추가
- `Bender`: 타겟 전용 구현체를 덮어쓰지 않도록 `rtl/tc_sram`을 `rtl` 타겟에 추가

### 수정
- `tc_sram`: Synopsys 엘라보레이션 오류 방지를 위해 `SimInit` 파라미터 정의에서 문자열 리터럴 제거
- `tc_clk:tc_clk_delay`: Verilator 및 합성 가드 추가

## 0.2.0 - 2020-03-18
### 추가
- 기술별 구현체 검증을 위한 테스트벤치와 함께 `tc_sram` 및 `tc_sram_xilinx` 추가

## 0.1.6 - 2019-11-18
### 추가
- README 추가
- 기여 가이드 추가

### 변경
- 유사한 주제의 모듈을 단일 파일로 통합하여 새 모듈 추가를 용이하게 함
- `cluster`와 `pulp` 간 분리를 `deprecated` 폴더로 이동. 기술 셀은 단일 솔루션으로 통일

## 0.1.1 - 2018-09-12
### 변경
- 릴리스 정리
- 변경 이력 관리 체계 도입
- 소스를 하위 폴더로 이동

## 0.1.0 - 2018-09-12
### 추가
- 최초 커밋
