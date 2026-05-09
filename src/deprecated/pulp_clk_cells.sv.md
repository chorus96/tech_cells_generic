# pulp_clk_cells.sv

`pulp_clock_*` 이름 체계를 사용하는 레거시 클럭 셀 래퍼 모음입니다. 내부적으로 [`src/rtl/tc_clk.sv`](../rtl/tc_clk.sv.md)의 `tc_clk_*` 셀을 인스턴스화합니다.

> **Deprecated**: 신규 설계에서는 `tc_clk_*` 셀을 직접 사용하세요.

## 포함 모듈 및 매핑

| 레거시 모듈 | 내부 매핑 |
|------------|-----------|
| `pulp_clock_and2` | `tc_clk_and2` |
| `pulp_clock_buffer` | `tc_clk_buffer` |
| `pulp_clock_gating` | `tc_clk_gating` |
| `pulp_clock_inverter` | `tc_clk_inverter` |
| `pulp_clock_mux2` | `tc_clk_mux2` |
| `pulp_clock_xor2` | `tc_clk_xor2` |
| `pulp_clock_delay` | 300ps 딜레이 (시뮬레이션 전용, `\`ifndef SYNTHESIS` 가드) |

## `pulp_clock_delay`

`tc_clk.sv`의 `tc_clk_delay`와 유사하지만, `\`ifndef VERILATOR` 가드 없이 `verilator lint_off ASSIGNDLY` 어노테이션만 사용합니다. Verilator에서 경고 없이 컴파일되지만 딜레이는 무시됩니다.

## `cluster_clk_cells.sv`와의 차이

두 파일은 동일한 기능을 제공하며, 이름 체계만 다릅니다:
- `cluster_clk_cells.sv`: `cluster_clock_*`
- `pulp_clk_cells.sv`: `pulp_clock_*` (+ `pulp_clock_delay` 추가)

## 관련 파일

- [`../rtl/tc_clk.sv`](../rtl/tc_clk.sv.md) — 현재 권장 클럭 셀
- [`cluster_clk_cells.sv`](cluster_clk_cells.sv.md) — 유사한 `cluster_clock_*` 레거시 래퍼
