# tc_pwr.sv

전력 관련 기술 셀(technology cell)들의 행동 모델 모음입니다. 레벨 시프터, 파워 게이팅, 아이솔레이션 셀을 포함합니다.

## 포함 모듈

### 레벨 시프터 (Level Shifter)

| 모듈 | 입력 | 출력 | 설명 |
|------|------|------|------|
| `tc_pwr_level_shifter_in` | `in_i` | `out_o` | 입력 방향 레벨 시프터 (feedthrough) |
| `tc_pwr_level_shifter_in_clamp_lo` | `in_i`, `clamp_i` | `out_o` | 입력 레벨 시프터 + `clamp_i`=1 시 `1'b0` 클램프 |
| `tc_pwr_level_shifter_in_clamp_hi` | `in_i`, `clamp_i` | `out_o` | 입력 레벨 시프터 + `clamp_i`=1 시 `1'b1` 클램프 |
| `tc_pwr_level_shifter_out` | `in_i` | `out_o` | 출력 방향 레벨 시프터 (feedthrough) |
| `tc_pwr_level_shifter_out_clamp_lo` | `in_i`, `clamp_i` | `out_o` | 출력 레벨 시프터 + `clamp_i`=1 시 `1'b0` 클램프 |
| `tc_pwr_level_shifter_out_clamp_hi` | `in_i`, `clamp_i` | `out_o` | 출력 레벨 시프터 + `clamp_i`=1 시 `1'b1` 클램프 |

### 파워 게이팅 (Power Gating)

| 모듈 | 입력 | 출력 | 설명 |
|------|------|------|------|
| `tc_pwr_power_gating` | `sleep_i` | `sleepout_o` | 파워 게이트 제어/상태 신호 (feedthrough) |

### 아이솔레이션 (Isolation)

| 모듈 | 입력 | 출력 | 설명 |
|------|------|------|------|
| `tc_pwr_isolation_lo` | `data_i`, `ena_i` | `data_o` | `ena_i`=0 시 `1'b0`으로 아이솔레이션 |
| `tc_pwr_isolation_hi` | `data_i`, `ena_i` | `data_o` | `ena_i`=0 시 `1'b1`으로 아이솔레이션 |

## 비고

모든 셀은 행동 모델로 단순 조합 논리(`assign`)로 구현됩니다. 실제 ASIC 구현 시 공정 라이브러리의 전력 관련 셀로 대체됩니다.

## 레거시 대응

- [`src/deprecated/cluster_pwr_cells.sv`](../deprecated/cluster_pwr_cells.sv.md) — `cluster_*` 이름으로 유사 기능 제공
- [`src/deprecated/pulp_pwr_cells.sv`](../deprecated/pulp_pwr_cells.sv.md) — `pulp_*` 이름으로 유사 기능 제공
