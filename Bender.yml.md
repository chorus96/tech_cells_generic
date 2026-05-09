# Bender.yml

Bender 패키지 매니페스트 파일로, 이 패키지의 이름과 의존성, 소스 파일 목록을 정의합니다.

## 의존성 그래프

```mermaid
flowchart TD
    TCG["tech_cells_generic\nv(current)"]
    CV["common_verification\nv0.2.6"]
    CLK_RST["clk_rst_gen.sv\n(시뮬레이션 클럭/리셋 생성기)"]
    SIM_CELLS["sim_timeout.sv\nstream_watchdog.sv\nsignal_highlighter.sv"]

    TCG -->|"Bender 의존성"| CV
    CV -->|"verilator/simulation 타겟"| CLK_RST
    CV -->|"simulation 타겟"| SIM_CELLS
```

## 소스 파일 타겟 조건 맵

```mermaid
flowchart TD
    ROOT["Bender.yml 소스 그룹"]

    ROOT --> SRAM_GRP["tc_sram 그룹\nall(any(not(asic), not(fpga), include_tc_sram),\nnot(exclude_tc_sram))"]
    ROOT --> CLK_GRP["tc_clk 그룹\nall(any(not(asic), not(fpga), include_tc_clk),\nnot(exclude_tc_clk))"]
    ROOT --> FPGA_GRP["fpga 그룹\nany(fpga, include_xilinx_xpm)"]
    ROOT --> DEPR_GRP["deprecated 그룹\nall(any(not(synthesis), include_deprecated),\nnot(exclude_deprecated))"]
    ROOT --> PWR_GRP["pwr_cells 그룹\nany(not(synthesis), include_pwr_cells)"]
    ROOT --> TEST_GRP["test 그룹\nany(test, include_tb_cells)"]
    ROOT --> ALWAYS["항상 포함\n(조건 없음)"]

    SRAM_GRP --> F1["src/rtl/tc_sram.sv\nsrc/rtl/tc_sram_impl.sv"]
    CLK_GRP --> F2["src/rtl/tc_clk.sv"]
    FPGA_GRP --> F3["src/fpga/pad_functional_xilinx.sv\nsrc/fpga/tc_clk_xilinx.sv\nsrc/fpga/tc_sram_xilinx.sv\nsrc/rtl/tc_sram_impl.sv"]
    DEPR_GRP --> F4["src/deprecated/cluster_pwr_cells.sv\ngeneric_memory.sv\ngeneric_rom.sv\npad_functional.sv\npulp_buffer.sv\npulp_pwr_cells.sv"]
    PWR_GRP --> F5["src/tc_pwr.sv"]
    TEST_GRP --> F6["test/tb_tc_sram.sv"]
    ALWAYS --> F7["src/deprecated/pulp_clock_gating_async.sv\ncluster_clk_cells.sv\npulp_clk_cells.sv"]
```

## 패키지 정보

- **이름**: `tech_cells_generic`

## 의존성

| 패키지 | 소스 | 버전 |
|--------|------|------|
| `common_verification` | GitHub (`chorus96/common_verification`) | 0.2.6 |

`common_verification`은 시뮬레이션용 클럭/리셋 생성기(`clk_rst_gen`) 등을 제공합니다.

## 타겟별 파일 포함 규칙

| 타겟 조합 | 포함 파일 그룹 |
|-----------|---------------|
| `rtl` (기본 시뮬레이션) | tc_sram, tc_clk, deprecated(일부), pwr_cells |
| `test` | + tb_tc_sram.sv |
| `verilator` | + common_verification의 clk_rst_gen 등 |
| `fpga` / `xilinx` | FPGA 구현체 (tc_sram_xilinx, tc_clk_xilinx 등) |
| `tech_cells_generic_exclude_deprecated` | deprecated 파일 제외 |
| `synthesis` | deprecated 파일 제외 (not(synthesis) 조건) |

## 관련 파일

- [`src_files.yml`](src_files.yml.md) — FuseSoC 스타일 소스 목록 (레거시)
- [`scripts/compile_vltor.sh`](scripts/compile_vltor.sh.md) — Verilator용 파일 목록 생성
- [`scripts/compile_vsim.sh`](scripts/compile_vsim.sh.md) — QuestaSim용 컴파일 스크립트
