# run_xsim.tcl

Vivado xsim으로 `tb_tc_sram`을 시뮬레이션하는 TCL 스크립트입니다. [`run_xsim.sh`](../run_xsim.sh.md)에 의해 호출됩니다.

## 동작 순서

1. **환경 변수 설정**: `XILINX_PART`, `XILINX_BOARD`가 설정되어 있지 않으면 Genesys2 보드 기본값으로 설정합니다.
2. **프로젝트 생성**: `tc_generic_sim` 프로젝트를 현재 디렉토리에 생성하고, 스레드 수를 8로 설정합니다.
3. **소스 추가**: `add_sources.tcl` (Bender 생성)을 소싱하여 설계 파일을 추가하고, 탑 모듈을 `tb_tc_sram`으로 설정합니다.
4. **1-포트 시뮬레이션**: `NumPorts=32'd1`로 xsim 시뮬레이션을 실행합니다.
5. **2-포트 시뮬레이션**: `NumPorts=32'd2`로 xsim 시뮬레이션을 실행합니다.

## 환경 변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `XILINX_PART` | `xc7k325tffg900-2` | 타겟 FPGA 파트 번호 |
| `XILINX_BOARD` | `digilentinc.com:genesys2:part0:1.1` | 타겟 보드 |

## 주의

- Vivado XPM 매크로 인식을 위해 `auto_detect_xpm` 명령 또는 `set_property XPM_LIBRARIES XPM_MEMORY [current_project]` 설정이 필요합니다.
- Xilinx SRAM은 항상 0으로 초기화됩니다(`SimInit` 고정).

## 관련 파일

- [`../run_xsim.sh`](../run_xsim.sh.md) — 이 스크립트를 호출하는 쉘 스크립트
- [`../../src/fpga/tc_sram_xilinx.sv`](../../src/fpga/tc_sram_xilinx.sv.md) — Xilinx XPM 기반 SRAM 구현체
