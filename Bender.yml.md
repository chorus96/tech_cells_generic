# Bender.yml

Bender 패키지 매니페스트 파일로, 이 패키지의 이름과 의존성, 소스 파일 목록을 정의합니다.

## 패키지 정보

- **이름**: `tech_cells_generic`

## 의존성

| 패키지 | 소스 | 버전 |
|--------|------|------|
| `common_verification` | GitHub (`chorus96/common_verification`) | 0.2.6 |

`common_verification`은 시뮬레이션용 클럭/리셋 생성기(`clk_rst_gen`) 등을 제공합니다.

## 소스 그룹 및 타겟 조건

| 파일 | 포함 조건 |
|------|-----------|
| `src/rtl/tc_sram.sv`, `src/rtl/tc_sram_impl.sv` | ASIC/FPGA가 아닌 환경이거나 `tech_cells_generic_include_tc_sram`이 설정되어 있고, `tech_cells_generic_exclude_tc_sram`이 없을 때 |
| `src/rtl/tc_clk.sv` | ASIC/FPGA가 아닌 환경이거나 `tech_cells_generic_include_tc_clk`이 설정되어 있고, `tech_cells_generic_exclude_tc_clk`이 없을 때 |
| `src/fpga/pad_functional_xilinx.sv`, `src/fpga/tc_clk_xilinx.sv`, `src/fpga/tc_sram_xilinx.sv`, `src/rtl/tc_sram_impl.sv` | `fpga` 타겟이거나 `tech_cells_generic_include_xilinx_xpm`이 설정된 경우 |
| `src/deprecated/*.sv` (pwr/clk 제외) | 합성이 아닌 환경이거나 `tech_cells_generic_include_deprecated`가 설정되고, `tech_cells_generic_exclude_deprecated`가 없을 때 |
| `src/tc_pwr.sv` | 합성이 아닌 환경이거나 `tech_cells_generic_include_pwr_cells`가 설정된 경우 |
| `test/tb_tc_sram.sv` | `test` 타겟이거나 `tech_cells_generic_include_tb_cells`가 설정된 경우 |
| `src/deprecated/pulp_clock_gating_async.sv`, `cluster_clk_cells.sv`, `pulp_clk_cells.sv` | 항상 포함 (조건 없음) |

## 관련 파일

- [`src_files.yml`](src_files.yml.md) — FuseSoC 스타일 소스 목록 (레거시)
- [`scripts/compile_vltor.sh`](scripts/compile_vltor.sh.md) — Verilator용 파일 목록 생성
- [`scripts/compile_vsim.sh`](scripts/compile_vsim.sh.md) — QuestaSim용 컴파일 스크립트
