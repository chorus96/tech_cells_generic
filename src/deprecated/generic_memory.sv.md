# generic_memory.sv

레거시 범용 SRAM 행동 모델입니다. PULP 플랫폼의 구형 인터페이스(active-low CEN, WEN)를 사용합니다.

> **Deprecated**: 신규 설계에서는 [`src/rtl/tc_sram.sv`](../rtl/tc_sram.sv.md)를 사용하세요.

## 모듈: `generic_memory`

### 파라미터

| 파라미터 | 기본값 | 설명 |
|----------|--------|------|
| `ADDR_WIDTH` | 12 | 주소 비트 폭. 워드 수 = `2^ADDR_WIDTH` |
| `DATA_WIDTH` | 32 | 데이터 비트 폭 |
| `BE_WIDTH` | `DATA_WIDTH/8` | 바이트 인에이블 폭 |

### 포트

| 포트 | 방향 | 설명 |
|------|------|------|
| `CLK` | input | 클럭 |
| `INITN` | input | 초기화 신호 (active high = 정상 동작) |
| `CEN` | input | 칩 인에이블 (active low) |
| `A` | input | 주소 |
| `WEN` | input | 쓰기 인에이블 (active low) |
| `D` | input | 쓰기 데이터 |
| `BEN` | input | 바이트 인에이블 (active low) |
| `Q` | output | 읽기 데이터 |

### 동작

- `INITN=1`, `CEN=0`, `WEN=0`, `BEN[i]=0`: 해당 바이트 쓰기
- `INITN=1`, `CEN=0`, `WEN=1`: 읽기 (1사이클 레이턴시)
- 비트 단위 `generate`로 바이트 인에이블 마스크 적용

### `tc_sram`과의 인터페이스 차이

| 항목 | `generic_memory` | `tc_sram` |
|------|-----------------|-----------|
| 인에이블 | Active low (`CEN`, `WEN`, `BEN`) | Active high (`req_i`, `we_i`, `be_i`) |
| 워드 수 | `2^ADDR_WIDTH` | 직접 지정(`NumWords`) |
| 포트 수 | 1 | 파라미터(`NumPorts`) |

## 관련 파일

- [`../rtl/tc_sram.sv`](../rtl/tc_sram.sv.md) — 현재 권장 SRAM 모듈
