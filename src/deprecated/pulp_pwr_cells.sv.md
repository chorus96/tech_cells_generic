# pulp_pwr_cells.sv

`pulp_*` 이름 체계를 사용하는 레거시 전력 셀 모음입니다. 행동 모델로 단순 조합 논리로 구현됩니다.

> **Deprecated**: 신규 설계에서는 [`src/tc_pwr.sv`](../tc_pwr.sv.md)의 `tc_pwr_*` 셀을 사용하세요.

## 포함 모듈

### 레벨 시프터

| 모듈 | 입력 | 출력 | 설명 |
|------|------|------|------|
| `pulp_level_shifter_in` | `in_i` | `out_o` | 입력 방향 레벨 시프터 (feedthrough) |
| `pulp_level_shifter_in_clamp` | `in_i`, `clamp_i` | `out_o` | `clamp_i`=1 시 `1'b0` 출력 |
| `pulp_level_shifter_inout` | `data_i` | `data_o` | 양방향 레벨 시프터 (feedthrough) |
| `pulp_level_shifter_out` | `in_i` | `out_o` | 출력 방향 레벨 시프터 (feedthrough) |
| `pulp_level_shifter_out_clamp` | `in_i`, `clamp_i` | `out_o` | `clamp_i`=1 시 `1'b0` 출력 |

### 파워 게이팅

| 모듈 | 입력 | 출력 | 설명 |
|------|------|------|------|
| `pulp_power_gating` | `sleep_i` | `sleepout_o` | 파워 게이트 신호 (feedthrough) |

### 아이솔레이션

| 모듈 | 입력 | 출력 | 설명 |
|------|------|------|------|
| `pulp_isolation_0` | `data_i`, `ena_i` | `data_o` | `ena_i`=0 시 `1'b0`으로 아이솔레이션 |
| `pulp_isolation_1` | `data_i`, `ena_i` | `data_o` | `ena_i`=0 시 `1'b1`으로 아이솔레이션 |

## `tc_pwr.sv`와의 차이

기능적으로 동일하며 이름 체계만 다릅니다. `tc_pwr.sv`는 `_clamp_lo`/`_clamp_hi`로 명확히 구분합니다.

## 관련 파일

- [`../tc_pwr.sv`](../tc_pwr.sv.md) — 현재 권장 전력 셀
- [`cluster_pwr_cells.sv`](cluster_pwr_cells.sv.md) — 유사한 `cluster_*` 레거시 래퍼
