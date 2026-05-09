# tb_tc_sram.sv

`tc_sram` 모듈의 기능 검증 테스트벤치입니다. 랜덤 읽기/쓰기 요청을 생성하고 골든 모델과 비교하여 오류 여부를 확인합니다.

## 모듈: `tb_tc_sram`

### 파라미터

| 파라미터 | 기본값 | 설명 |
|----------|--------|------|
| `NumPorts` | 2 | SRAM 포트 수 |
| `Latency` | 1 | 읽기 레이턴시 (클럭 사이클) |
| `NumWords` | 1024 | SRAM 워드 수 |
| `DataWidth` | 64 | 데이터 비트 폭 |
| `ByteWidth` | 8 | 바이트 비트 폭 |
| `NoReq` | 200000 | 포트당 요청 횟수 |
| `SimInit` | `"zeros"` | SRAM 초기화 방식 |
| `CyclTime` | 10ns | 클럭 주기 |
| `ApplTime` | 2ns | 클럭 에지 후 자극 인가 지연 |
| `TestTime` | 8ns | 클럭 에지 후 결과 검사 시점 |

### 구조

#### 자극 생성 (`gen_stimuli`)
각 포트마다 독립적인 `initial` 블록이 실행됩니다:
- 리셋 해제 후 10 사이클 대기
- `NoReq`회 반복하여 랜덤 쓰기/읽기 요청 생성
- `#ApplTime` 지연 후 신호 인가 (클럭 에지와 타이밍 분리)
- 완료 시 `done[i]` 신호 어서트

#### 골든 모델 (`proc_golden_model`)
- SRAM 초기화 후 클럭마다 쓰기 요청을 그림자 메모리 배열(`memory[]`)에 반영
- `#TestTime`에 `check_read` 태스크를 `fork...join_none`으로 병렬 실행

#### 읽기 검증 (`check_read` 태스크)
- 읽기 요청이 있을 때만 동작
- `Latency` 사이클 후 `#TestTime` 시점에 실제 출력과 골든 모델 비교
- 불일치 시 `$warning` 출력 및 `failed_test` 카운터 증가

#### 종료 (`proc_stop`)
- 모든 포트의 `done` 신호가 어서트될 때까지 대기
- 10 사이클 후 `$info("Simulation done, errors: %0d", failed_test)` 출력 및 `$stop()`

### 합격 기준

시뮬레이션 로그에서 `errors: 0` 문자열이 출력되면 통과입니다.

## 시뮬레이션 스크립트

| 스크립트 | 설명 |
|----------|------|
| [`../scripts/run_vsim.sh`](../scripts/run_vsim.sh.md) | QuestaSim으로 162개 파라미터 조합 실행 |
| [`../scripts/run_vltor.sh`](../scripts/run_vltor.sh.md) | Verilator로 162개 파라미터 조합 실행 |

## 관련 파일

- [`../src/rtl/tc_sram.sv`](../src/rtl/tc_sram.sv.md) — 검증 대상 모듈
