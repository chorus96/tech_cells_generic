# pulp_clock_gating_async.sv

비동기 인에이블 신호를 동기화하는 클럭 게이팅 셀입니다. 비동기 enable 신호를 다단 플립플롭으로 동기화한 뒤 `pulp_clock_gating`(ICG)으로 클럭을 게이팅합니다.

> **참고**: 파일 내 주석에 "This is not really a tech cell - move it to common cells"라고 기재되어 있습니다.  
> Bender.yml에서 타겟 조건 없이 항상 포함됩니다 (`tech_cells_generic_exclude_deprecated`로도 제외 불가).

## 모듈: `pulp_clock_gating_async`

### 파라미터

| 파라미터 | 기본값 | 설명 |
|----------|--------|------|
| `STAGES` | 2 | 동기화 플립플롭 단 수 |

### 포트

| 포트 | 방향 | 설명 |
|------|------|------|
| `clk_i` | input | 클럭 |
| `rstn_i` | input | 비동기 리셋 (active low) |
| `en_async_i` | input | 비동기 인에이블 신호 |
| `en_ack_o` | output | 동기화 완료된 인에이블 신호 |
| `test_en_i` | input | 테스트 인에이블 (DFT) |
| `clk_o` | output | 게이팅된 클럭 출력 |

### 동작

```
en_async_i → [STAGES단 FF 동기화] → r_reg[STAGES-1] → pulp_clock_gating → clk_o
                                              ↓
                                         en_ack_o
```

1. `en_async_i`를 `STAGES`개의 플립플롭으로 클럭 도메인에 동기화
2. 동기화된 신호(`r_reg[STAGES-1]`)로 `pulp_clock_gating`(ICG) 구동
3. `en_ack_o`로 인에이블 승인 신호 출력

## 관련 파일

- [`pulp_clk_cells.sv`](pulp_clk_cells.sv.md) — `pulp_clock_gating` 정의 포함
- [`../rtl/tc_clk.sv`](../rtl/tc_clk.sv.md) — 기본 `tc_clk_gating` 셀
