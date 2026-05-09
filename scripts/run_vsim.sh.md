# run_vsim.sh

QuestaSim으로 `tb_tc_sram` 테스트벤치를 다양한 파라미터 조합으로 실행하는 스크립트입니다.

## 사전 조건

`compile_vsim.sh`를 먼저 실행하여 QuestaSim 라이브러리가 컴파일되어 있어야 합니다.

## 동작

`call_vsim` 함수가 각 파라미터 조합에 대해 다음을 수행합니다:

1. `vsim tb_tc_sram -G<파라미터>=<값> ...` — 런타임 파라미터 오버라이드로 시뮬레이션 실행
2. `run -all` — 시뮬레이션을 끝까지 실행
3. `vsim.log`에서 `Errors: 0,` 문자열을 grep하여 통과 여부 확인

## 파라미터 스윕

| 파라미터 | 값 | 설명 |
|----------|----|------|
| `NumPorts` | 1, 2 | SRAM 포트 수 |
| `Latency` | 0, 1, 2 | 읽기 레이턴시 (클럭 사이클) |
| `NumWords` | 1, 420, 1024 | SRAM 워드 수 |
| `DataWidth` | 1, 42, 64 | 데이터 비트 폭 |
| `ByteWidth` | 1, 8, 9 | 바이트 비트 폭 |

총 **2 × 3 × 3 × 3 × 3 = 162** 조합을 순차 실행합니다.

## 환경 변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `VSIM` | `vsim` | 사용할 QuestaSim 실행 파일 경로 |

## 사용법

```bash
bash scripts/compile_vsim.sh   # 컴파일
bash scripts/run_vsim.sh       # 전체 파라미터 스윕 시뮬레이션
```

## 관련 파일

- [`compile_vsim.sh`](compile_vsim.sh.md) — 사전 컴파일 스크립트
- [`run_vltor.sh`](run_vltor.sh.md) — Verilator 대응 스크립트
- [`../test/tb_tc_sram.sv`](../test/tb_tc_sram.sv.md) — 실행되는 테스트벤치
