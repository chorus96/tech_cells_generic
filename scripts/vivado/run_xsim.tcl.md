# run_xsim.tcl

Vivado xsim으로 `tb_tc_sram`을 시뮬레이션하는 TCL 스크립트입니다. [`run_xsim.sh`](../run_xsim.sh.md)에 의해 배치 모드로 호출됩니다.

## 실행 흐름

```mermaid
flowchart TD
    START([vivado -mode batch\n-source run_xsim.tcl]) --> ENV["환경 변수 확인\nXILINX_PART / XILINX_BOARD"]
    ENV -->|"미설정"| DEF["기본값 적용\nPART: xc7k325tffg900-2\nBOARD: Genesys2"]
    ENV -->|"설정됨"| PROJ
    DEF --> PROJ

    PROJ["create_project tc_generic_sim\n(배치 모드, 강제 재생성)"] --> THREAD["set_param\ngeneral.maxThreads 8"]
    THREAD --> SRC["source add_sources.tcl\n(Bender 생성 소스 추가)"]
    SRC --> TOP["set_property top tb_tc_sram\nset_property top_lib xil_defaultlib"]

    TOP --> SIM1_SETUP["set_property generic\nNumPorts=32'd1"]
    SIM1_SETUP --> SIM1["launch_simulation\nrun -all\nclose_sim"]

    SIM1 --> SIM2_SETUP["set_property generic\nNumPorts=32'd2"]
    SIM2_SETUP --> SIM2["launch_simulation\nrun -all\nclose_sim"]
    SIM2 --> END([완료])
```

## 프로젝트 구성

```mermaid
flowchart LR
    subgraph VIVADO_PROJ["tc_generic_sim 프로젝트"]
        SRC_SET["sources_1\n(설계 파일)"]
        SIM_SET["sim_1\n(시뮬레이션 설정)"]
        TOP_MOD["top: tb_tc_sram\nlib: xil_defaultlib"]
    end

    ADD_SRC["add_sources.tcl"] --> SRC_SET
    TOP_MOD --> SIM_SET
    SIM_SET -->|"NumPorts=1"| XPM1["xpm_memory_spram\n(1-포트)"]
    SIM_SET -->|"NumPorts=2"| XPM2["xpm_memory_tdpram\n(2-포트)"]
```

## 시뮬레이션 설정 (2회)

| 실행 | `NumPorts` | XPM 매크로 |
|------|-----------|-----------|
| 1차 | `32'd1` | `xpm_memory_spram` |
| 2차 | `32'd2` | `xpm_memory_tdpram` |

## 환경 변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `XILINX_PART` | `xc7k325tffg900-2` | 타겟 FPGA 파트 번호 (Kintex-7) |
| `XILINX_BOARD` | `digilentinc.com:genesys2:part0:1.1` | 타겟 보드 (Digilent Genesys2) |

## XPM 사전 설정 필요

```tcl
# Vivado에서 XPM 매크로 인식을 위해 필요 (외부 설정):
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
# 또는
auto_detect_xpm
```

## 관련 파일

- [`../run_xsim.sh`](../run_xsim.sh.md) — 이 스크립트를 호출하는 쉘 스크립트
- [`../../src/fpga/tc_sram_xilinx.sv`](../../src/fpga/tc_sram_xilinx.sv.md) — XPM 기반 SRAM 구현체
- [`../../src/fpga/tc_clk_xilinx.sv`](../../src/fpga/tc_clk_xilinx.sv.md) — Xilinx 클럭 셀
