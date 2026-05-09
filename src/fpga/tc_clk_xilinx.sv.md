# tc_clk_xilinx.sv

Xilinx FPGA 구현을 위한 클럭 셀 모음입니다. [`src/rtl/tc_clk.sv`](../rtl/tc_clk.sv.md)와 동일한 모듈 인터페이스를 제공하며, FPGA 합성 시 이 파일로 대체됩니다.

## 포함 모듈

| 모듈 | 구현 방식 | 비고 |
|------|-----------|------|
| `tc_clk_and2` | `assign clk_o = clk0_i & clk1_i` | RTL과 동일 |
| `tc_clk_buffer` | `assign clk_o = clk_i` | RTL과 동일 |
| `tc_clk_gating` | `assign clk_o = clk_i` | **클럭 게이팅 비활성화** (feedthrough) |
| `tc_clk_inverter` | `assign clk_o = ~clk_i` | RTL과 동일 |
| `tc_clk_mux2` | Xilinx `BUFGMUX` 프리미티브 | 글로벌 클럭 버퍼 멀티플렉서 |
| `tc_clk_xor2` | `assign clk_o = clk0_i ^ clk1_i` | RTL과 동일 |
| `tc_clk_or2` | `assign clk_o = clk0_i \| clk1_i` | RTL과 동일 |

## FPGA 특이사항

### `tc_clk_gating` — 클럭 게이팅 비활성화

FPGA는 ASIC의 ICG(Integrated Clock Gating) 셀과 동작 방식이 다릅니다. 예상치 못한 동작을 방지하기 위해 FPGA에서는 클럭 게이팅 없이 클럭을 그대로 통과시킵니다.

### `tc_clk_mux2` — `BUFGMUX`

Xilinx의 글로벌 클럭 버퍼 멀티플렉서(`BUFGMUX`)를 사용합니다. RTL 버전과 달리 글로벌 클럭 네트워크를 통해 라우팅됩니다.

> `tc_clk_delay`는 이 파일에 포함되지 않습니다 (시뮬레이션 전용 셀).

## 관련 파일

- [`../rtl/tc_clk.sv`](../rtl/tc_clk.sv.md) — RTL(시뮬레이션) 행동 모델
- [`tc_sram_xilinx.sv`](tc_sram_xilinx.sv.md) — Xilinx SRAM 구현체
