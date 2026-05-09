# tc_sram.sv

설정 가능한 범용 SRAM의 행동 모델(behavioral model)입니다. RTL 시뮬레이션용이며, ASIC 구현 시 공정별 메모리 매크로로 대체됩니다.

## 모듈: `tc_sram`

### 파라미터

| 파라미터 | 기본값 | 설명 |
|----------|--------|------|
| `NumWords` | 1024 | 메모리 워드 수. 주소 폭 = `$clog2(NumWords)` |
| `DataWidth` | 128 | 데이터 비트 폭 |
| `ByteWidth` | 8 | 바이트 비트 폭. Byte Enable 폭 = `ceil(DataWidth/ByteWidth)` |
| `NumPorts` | 2 | 읽기/쓰기 포트 수 (각 포트는 풀 포트) |
| `Latency` | 1 | 읽기 레이턴시 (클럭 사이클 수) |
| `SimInit` | `"none"` | 초기화 방식: `"zeros"`, `"ones"`, `"random"`, `"none"` |
| `PrintSimCfg` | 0 | 시뮬레이션 시작 시 설정 정보 출력 여부 |
| `ImplKey` | `"none"` | 구현체 참조 키 (공정별 매핑용) |
| `FPGAImplKey` | `"auto"` | FPGA 구현체 참조 키 |

### 포트

| 포트 | 방향 | 설명 |
|------|------|------|
| `clk_i` | input | 클럭 |
| `rst_ni` | input | 비동기 리셋 (active low) |
| `req_i[NumPorts-1:0]` | input | 요청 (active high) |
| `we_i[NumPorts-1:0]` | input | 쓰기 인에이블 (active high) |
| `addr_i[NumPorts-1:0]` | input | 요청 주소 |
| `wdata_i[NumPorts-1:0]` | input | 쓰기 데이터 |
| `be_i[NumPorts-1:0]` | input | 바이트 인에이블 (active high) |
| `rdata_o[NumPorts-1:0]` | output | 읽기 데이터 (`Latency` 사이클 후 유효) |

### 동작

- **쓰기 시 읽기 데이터**: `we_i`가 활성화된 경우 `rdata_o`는 갱신되지 않습니다.
- **주소 충돌**: 여러 포트가 동일 주소에 쓰기 시, 낮은 인덱스 포트의 쓰기가 먼저 수행되고 높은 인덱스 포트가 덮어씁니다.
- **Latency=0**: 조합 논리로 읽기 데이터 즉시 출력
- **Latency>0**: 레지스터 파이프라인을 통해 `Latency` 사이클 후 출력

### Verilator 호환성

`\`ifndef VERILATOR` 가드로 concurrent assertion과 설정 출력 블록이 보호됩니다. Verilator 실행 시 자동으로 `VERILATOR` 매크로가 정의되어 이 블록들이 비활성화됩니다.

### `SimInit="none"` 최적화

`SimInit == "none"` 시 SRAM 배열 초기화를 생략하여 Verilator 등에서 시뮬레이션 성능이 향상됩니다.

## 관련 파일

- [`tc_sram_impl.sv`](tc_sram_impl.sv.md) — 구현체 IO를 추가한 래퍼 모듈
- [`../fpga/tc_sram_xilinx.sv`](../fpga/tc_sram_xilinx.sv.md) — Xilinx XPM 기반 구현체
- [`../../test/tb_tc_sram.sv`](../../test/tb_tc_sram.sv.md) — 테스트벤치
