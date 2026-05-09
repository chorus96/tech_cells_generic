# tc_sram.sv

설정 가능한 범용 SRAM의 행동 모델(behavioral model)입니다. RTL 시뮬레이션용이며, ASIC 구현 시 공정별 메모리 매크로로 대체됩니다.

## 블록 다이어그램

```mermaid
block-beta
  columns 5

  space:1
  clk_i(["clk_i"])
  space:1
  rst_ni(["rst_ni"])
  space:1

  space:5

  req_i(["req_i\n[NumPorts-1:0]"])
  space:1
  TC["        tc_sram        \n───────────────────\n sram[NumWords-1:0]\n r_addr_q[NumPorts]\n rdata_q pipeline"]
  space:1
  rdata_o(["rdata_o\n[NumPorts-1:0]"])

  we_i(["we_i\n[NumPorts-1:0]"])
  space:3
  space:1

  addr_i(["addr_i\n[NumPorts-1:0]"])
  space:5

  wdata_i(["wdata_i\n[NumPorts-1:0]"])
  space:5

  be_i(["be_i\n[NumPorts-1:0]"])
  space:5

  clk_i --> TC
  rst_ni --> TC
  req_i --> TC
  we_i --> TC
  addr_i --> TC
  wdata_i --> TC
  be_i --> TC
  TC --> rdata_o
```

## 내부 아키텍처

### Latency = 0 경로

```mermaid
flowchart LR
    REQ["req_i[i]\nwe_i[i]"]
    ADDR["addr_i[i]"]
    MUX{"req_i && !we_i ?"}
    SRAM[("sram[]")]
    RADDRQ["r_addr_q[i]"]
    OUT["rdata_o[i]"]

    REQ --> MUX
    ADDR --> MUX
    MUX -- "Yes: sram[addr_i]" --> OUT
    MUX -- "No: sram[r_addr_q]" --> OUT
    ADDR -->|"!req 시 저장"| RADDRQ
    RADDRQ --> SRAM
    ADDR --> SRAM
    SRAM --> OUT
```

### Latency > 0 파이프라인

```mermaid
flowchart LR
    SRAM[("sram[addr_i]")]
    R0["rdata_q[i][Latency-1]"]
    R1["rdata_q[i][Latency-2]"]
    RN["rdata_q[i][0]"]
    OUT["rdata_o[i]"]

    SRAM -->|"clk"| R0
    R0 -->|"clk"| R1
    R1 -. "..." .-> RN
    RN -->|"조합"| OUT
```

### 쓰기 동작 (Byte Enable)

```mermaid
flowchart TD
    REQ["req_i && we_i"]
    BE["be_i[j] (j=0..BeWidth-1)"]
    SRAM[("sram[addr_i]\n[j*ByteWidth +: ByteWidth]")]

    REQ --> BE
    BE -->|"be_i[j] = 1"| SRAM
    BE -->|"be_i[j] = 0"| NOP["(변경 없음)"]
```

## 모듈: `tc_sram`

### 파라미터

| 파라미터 | 기본값 | 설명 |
|----------|--------|------|
| `NumWords` | 1024 | 메모리 워드 수. 주소 폭 = `$clog2(NumWords)` |
| `DataWidth` | 128 | 데이터 비트 폭 |
| `ByteWidth` | 8 | 바이트 비트 폭. Byte Enable 폭 = `ceil(DataWidth/ByteWidth)` |
| `NumPorts` | 2 | 읽기/쓰기 포트 수 (각 포트는 풀 포트) |
| `Latency` | 1 | 읽기 레이턴시 (클럭 사이클 수) |
| `SimInit` | `"none"` | 초기화 방식: `"zeros"` / `"ones"` / `"random"` / `"none"` |
| `PrintSimCfg` | 0 | 시뮬레이션 시작 시 설정 정보 출력 여부 |
| `ImplKey` | `"none"` | 구현체 참조 키 (공정별 매핑용) |
| `FPGAImplKey` | `"auto"` | FPGA 구현체 참조 키 |

### 의존 파라미터 (자동 계산)

```
AddrWidth = (NumWords > 1) ? $clog2(NumWords) : 1
BeWidth   = ceil(DataWidth / ByteWidth)
```

### 포트

| 포트 | 방향 | 폭 | 설명 |
|------|------|----|------|
| `clk_i` | input | 1 | 클럭 |
| `rst_ni` | input | 1 | 비동기 리셋 (active low) |
| `req_i` | input | NumPorts | 요청 (active high) |
| `we_i` | input | NumPorts | 쓰기 인에이블 (active high) |
| `addr_i` | input | NumPorts × AddrWidth | 요청 주소 |
| `wdata_i` | input | NumPorts × DataWidth | 쓰기 데이터 |
| `be_i` | input | NumPorts × BeWidth | 바이트 인에이블 (active high) |
| `rdata_o` | output | NumPorts × DataWidth | 읽기 데이터 (`Latency` 사이클 후 유효) |

## 동작 규칙

### 읽기/쓰기 타이밍

```
Clock:   ___/‾‾‾\___/‾‾‾\___/‾‾‾\___
req_i:   ___/‾‾‾‾‾‾‾\_______________   (1사이클 요청)
we_i:    ________/‾‾‾\_______________   (쓰기)
rdata_o: ___________________________/‾‾ (Latency=1 후 유효, 읽기 시)
```

### 주소 충돌 처리

| 상황 | 결과 |
|------|------|
| 포트 0, 포트 1 동시 쓰기 (같은 주소) | 포트 0 먼저 쓰고, 포트 1이 덮어씀 |
| 쓰기 중 읽기 (`we_i=1`) | `rdata_o` 유지 (갱신 없음) |

### SimInit 처리 분기

```mermaid
flowchart TD
    SI{"SimInit"}
    SI -->|"none"| NOINIT["초기화 생략\n(시뮬레이션 성능 향상)"]
    SI -->|"zeros"| ZEROS["all 0으로 초기화"]
    SI -->|"ones"| ONES["all 1로 초기화"]
    SI -->|"random"| RAND["$urandom()으로 초기화"]
    NOINIT --> RST["리셋 시: r_addr_q만 클리어"]
    ZEROS & ONES & RAND --> RST2["리셋 시: sram[], r_addr_q, rdata_q 모두 초기화"]
```

## Verilator / 합성 가드

```
`ifndef VERILATOR
`ifndef TARGET_SYNTHESIS
  // 아래 블록 활성화:
  // - p_assertions: 파라미터 유효성 immediate assertion
  // - p_sim_hello:  PrintSimCfg=1 시 설정 출력
  // - gen_assertions: 주소 범위 concurrent assertion
`endif
`endif
```

## 관련 파일

- [`tc_sram_impl.sv`](tc_sram_impl.sv.md) — 구현체 IO(`impl_i`/`impl_o`)를 추가한 래퍼
- [`../fpga/tc_sram_xilinx.sv`](../fpga/tc_sram_xilinx.sv.md) — Xilinx XPM 기반 구현체
- [`../../test/tb_tc_sram.sv`](../../test/tb_tc_sram.sv.md) — 기능 검증 테스트벤치
