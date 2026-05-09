# tc_clk.sv

클럭 관련 기술 셀(technology cell)들의 행동 모델(behavioral model) 모음입니다. RTL 시뮬레이션용이며, ASIC 구현 시 해당 공정 라이브러리의 실제 셀로 대체됩니다.

## 포함 모듈

| 모듈 | 설명 |
|------|------|
| `tc_clk_and2` | 2-입력 클럭 AND 게이트 |
| `tc_clk_buffer` | 클럭 버퍼 (feedthrough) |
| `tc_clk_gating` | 통합 클럭 게이팅 셀 (ICG). 클럭 로우 구간에 enable을 래치 |
| `tc_clk_inverter` | 클럭 인버터 |
| `tc_clk_mux2` | 2-입력 클럭 멀티플렉서 (글리치 비보호) |
| `tc_clk_xor2` | 2-입력 클럭 XOR |
| `tc_clk_or2` | 2-입력 클럭 OR |
| `tc_clk_delay` | 프로그래머블 클럭 딜레이 (시뮬레이션 전용, `SYNTHESIS`/`VERILATOR` 미정의 시에만 포함) |

## 주요 설계 사항

### `tc_clk_gating`
```
파라미터: IS_FUNCTIONAL (bit) — 기능적 필요성 힌트
  - 1: 기능상 필수 게이팅
  - 0: 전력 절감 목적, 툴이 feedthrough로 대체 가능
포트: clk_i, en_i, test_en_i → clk_o
동작: clk_i가 LOW일 때 (en_i | test_en_i)를 래치 → 글리치 방지
```

### `tc_clk_mux2` 경고
준정적(quasi-static) 클럭 전환 전용입니다. 동적 클럭 전환 시 글리치가 발생할 수 있습니다. 글리치 없는 동적 전환이 필요하면 `common_cells`의 `clk_mux_glitch_free`를 사용하세요.

### `tc_clk_delay`
`\`ifndef SYNTHESIS` 및 `\`ifndef VERILATOR` 가드로 보호되어 있어 합성 및 Verilator 시뮬레이션에서는 비활성화됩니다.

## Xilinx FPGA 대응

FPGA 구현 시 [`src/fpga/tc_clk_xilinx.sv`](../fpga/tc_clk_xilinx.sv.md)로 대체됩니다. Xilinx 버전의 `tc_clk_mux2`는 `BUFGMUX` 프리미티브를 사용합니다.

## 레거시 래퍼

- [`src/deprecated/cluster_clk_cells.sv`](../deprecated/cluster_clk_cells.sv.md) — `cluster_clock_*` 이름으로 래핑
- [`src/deprecated/pulp_clk_cells.sv`](../deprecated/pulp_clk_cells.sv.md) — `pulp_clock_*` 이름으로 래핑
