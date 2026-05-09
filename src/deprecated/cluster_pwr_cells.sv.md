# cluster_pwr_cells.sv

`cluster_level_shifter_*` 이름 체계를 사용하는 레거시 전력 셀 모음입니다. 행동 모델로 단순 조합 논리로 구현됩니다.

> **Deprecated**: 신규 설계에서는 [`src/tc_pwr.sv`](../tc_pwr.sv.md)의 `tc_pwr_*` 셀을 사용하세요.

## 포함 모듈

| 모듈 | 입력 | 출력 | 설명 |
|------|------|------|------|
| `cluster_level_shifter_in` | `in_i` | `out_o` | 입력 방향 레벨 시프터 (feedthrough) |
| `cluster_level_shifter_in_clamp` | `in_i`, `clamp_i` | `out_o` | 입력 레벨 시프터 + `clamp_i`=1 시 `1'b0` 출력 |
| `cluster_level_shifter_inout` | `data_i` | `data_o` | 양방향 레벨 시프터 (feedthrough) |
| `cluster_level_shifter_out` | `in_i` | `out_o` | 출력 방향 레벨 시프터 (feedthrough) |
| `cluster_level_shifter_out_clamp` | `in_i`, `clamp_i` | `out_o` | 출력 레벨 시프터 + `clamp_i`=1 시 `1'b0` 출력 |

## `tc_pwr`와의 차이

`tc_pwr.sv`는 `_clamp_lo`/`_clamp_hi` 구분과 파워 게이팅, 아이솔레이션 셀을 추가로 제공합니다. 이 파일의 `clamp` 동작은 `clamp_lo`(0으로 클램프)에만 해당합니다.

## 관련 파일

- [`../tc_pwr.sv`](../tc_pwr.sv.md) — 현재 권장 전력 셀
- [`pulp_pwr_cells.sv`](pulp_pwr_cells.sv.md) — 유사한 `pulp_*` 레거시 래퍼
