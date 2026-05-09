# tc_pwr.sv

전력 관련 기술 셀(technology cell)들의 행동 모델 모음입니다. 레벨 시프터, 파워 게이팅, 아이솔레이션 셀을 포함합니다.

## 전체 셀 구조

```mermaid
flowchart LR
    subgraph LS_IN["레벨 시프터 (입력 방향)"]
        direction TB
        LS1["tc_pwr_level_shifter_in\nin_i → out_o"]
        LS2["tc_pwr_level_shifter_in_clamp_lo\nin_i, clamp_i → out_o\n(clamp=1: 0 출력)"]
        LS3["tc_pwr_level_shifter_in_clamp_hi\nin_i, clamp_i → out_o\n(clamp=1: 1 출력)"]
    end
    subgraph LS_OUT["레벨 시프터 (출력 방향)"]
        direction TB
        LS4["tc_pwr_level_shifter_out\nin_i → out_o"]
        LS5["tc_pwr_level_shifter_out_clamp_lo\nin_i, clamp_i → out_o\n(clamp=1: 0 출력)"]
        LS6["tc_pwr_level_shifter_out_clamp_hi\nin_i, clamp_i → out_o\n(clamp=1: 1 출력)"]
    end
    subgraph PWR["파워 & 아이솔레이션"]
        direction TB
        PG["tc_pwr_power_gating\nsleep_i → sleepout_o"]
        ISO_LO["tc_pwr_isolation_lo\ndata_i, ena_i → data_o\n(ena=0: 0 출력)"]
        ISO_HI["tc_pwr_isolation_hi\ndata_i, ena_i → data_o\n(ena=0: 1 출력)"]
    end
```

## 레벨 시프터 동작

```mermaid
flowchart LR
    subgraph "clamp_lo / clamp_hi"
        IN_D(in_i)
        IN_C(clamp_i)
        MUX{"clamp_i ?"}
        OUT_D(out_o)

        IN_C -->|"1"| MUX
        IN_D --> MUX
        MUX -->|"clamp=0: in_i"| OUT_D
        MUX -->|"clamp=1 (lo): 1'b0\nclamp=1 (hi): 1'b1"| OUT_D
    end
```

**진리표**

| `clamp_i` | `in_i` | `out_o` (clamp_lo) | `out_o` (clamp_hi) |
|-----------|--------|---------------------|---------------------|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 1 |
| 1 | x | **0** | **1** |

## 아이솔레이션 셀 동작

```mermaid
flowchart LR
    subgraph "isolation_lo"
        D1(data_i)
        E1(ena_i)
        M1{"ena_i ?"}
        O1(data_o)
        D1 --> M1
        E1 --> M1
        M1 -->|"ena=1: data_i"| O1
        M1 -->|"ena=0: 1'b0"| O1
    end

    subgraph "isolation_hi"
        D2(data_i)
        E2(ena_i)
        M2{"ena_i ?"}
        O2(data_o)
        D2 --> M2
        E2 --> M2
        M2 -->|"ena=1: data_i"| O2
        M2 -->|"ena=0: 1'b1"| O2
    end
```

**사용 맥락**: 전원이 꺼진 도메인에서 나오는 신호를 안정된 값으로 고정하여 활성 도메인의 오동작을 방지합니다.

## 파워 게이팅 흐름

```mermaid
flowchart TD
    CTRL["파워 컨트롤러"] -->|"sleep_i"| PG["tc_pwr_power_gating\nsleepout_o = sleep_i"]
    PG -->|"sleepout_o"| SWITCH["파워 스위치\n(공정 셀로 대체)"]
    SWITCH -->|"전원 차단/인가"| DOMAIN["전원 도메인"]

    DOMAIN -->|"신호 출력"| ISO_LO["tc_pwr_isolation_lo\n(도메인 꺼짐 시 0 고정)"]
    ISO_LO --> ACTIVE["활성 도메인"]
```

## 포함 모듈 요약

| 모듈 | 동작 (행동 모델) | 용도 |
|------|-----------------|------|
| `tc_pwr_level_shifter_in` | `out_o = in_i` | 저→고 전압 도메인 입력 |
| `tc_pwr_level_shifter_in_clamp_lo` | `out_o = clamp_i ? 0 : in_i` | 입력 + 저 클램프 |
| `tc_pwr_level_shifter_in_clamp_hi` | `out_o = clamp_i ? 1 : in_i` | 입력 + 고 클램프 |
| `tc_pwr_level_shifter_out` | `out_o = in_i` | 고→저 전압 도메인 출력 |
| `tc_pwr_level_shifter_out_clamp_lo` | `out_o = clamp_i ? 0 : in_i` | 출력 + 저 클램프 |
| `tc_pwr_level_shifter_out_clamp_hi` | `out_o = clamp_i ? 1 : in_i` | 출력 + 고 클램프 |
| `tc_pwr_power_gating` | `sleepout_o = sleep_i` | 파워 게이트 제어 |
| `tc_pwr_isolation_lo` | `data_o = ena_i ? data_i : 0` | 아이솔레이션 (저) |
| `tc_pwr_isolation_hi` | `data_o = ena_i ? data_i : 1` | 아이솔레이션 (고) |

## 레거시 대응

- [`../deprecated/cluster_pwr_cells.sv`](../deprecated/cluster_pwr_cells.sv.md) — `cluster_*` 이름
- [`../deprecated/pulp_pwr_cells.sv`](../deprecated/pulp_pwr_cells.sv.md) — `pulp_*` 이름
