# run_vltor.sh

Verilator로 `tb_tc_sram` 테스트벤치를 다양한 파라미터 조합으로 컴파일하고 실행하는 스크립트입니다. QuestaSim의 [`run_vsim.sh`](run_vsim.sh.md)에 대응합니다.

## 사전 조건

`compile_vltor.sh`를 먼저 실행하여 `compile_vltor.flist`가 존재해야 합니다.

## 동작

파라미터 조합마다 다음을 수행합니다:

1. `work-vltor/P{N}_L{N}_W{N}_D{N}_B{N}/` 빌드 디렉토리 생성
2. `verilator --binary --timing --assert`로 해당 파라미터 설정으로 컴파일 → `Vtb_tc_sram` 실행 파일 생성
3. 시뮬레이션 실행 후 로그에서 `errors: 0` 확인으로 통과/실패 판정

## 파라미터 스윕

| 파라미터 | 값 | 설명 |
|----------|----|------|
| `NumPorts` | 1, 2 | SRAM 포트 수 |
| `Latency` | 0, 1, 2 | 읽기 레이턴시 (클럭 사이클) |
| `NumWords` | 1, 420, 1024 | SRAM 워드 수 |
| `DataWidth` | 1, 42, 64 | 데이터 비트 폭 |
| `ByteWidth` | 1, 8, 9 | 바이트 비트 폭 |

총 **2 × 3 × 3 × 3 × 3 = 162** 조합을 순차 실행합니다.

## 주요 Verilator 플래그

| 플래그 | 설명 |
|--------|------|
| `--binary` | C++ 생성 + 컴파일 + 링크를 한 번에 처리 |
| `--timing` | `#delay`, `fork...join_none` 등 타이밍 구문 지원 |
| `--assert` | SystemVerilog assertion 활성화 |
| `--timescale 1ns/1ps` | 타임스케일 설정 |
| `-Wno-WIDTHTRUNC` 등 | 이 테스트벤치에서 예상되는 경고 억제 |

## $stop 처리

테스트벤치가 `$stop()`으로 종료하면 Verilator가 `abort()`를 호출합니다. `|| true`로 비정상 종료를 무시하고 로그의 `errors: 0` 문자열로 성공 여부를 판정합니다.

## 환경 변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `VERILATOR` | `verilator` | 사용할 Verilator 실행 파일 경로 |

## 사용법

```bash
bash scripts/compile_vltor.sh   # flist 생성
bash scripts/run_vltor.sh       # 전체 파라미터 스윕 시뮬레이션
```

## 관련 파일

- [`compile_vltor.sh`](compile_vltor.sh.md) — flist 생성 스크립트
- [`run_vsim.sh`](run_vsim.sh.md) — QuestaSim 대응 스크립트
- [`../test/tb_tc_sram.sv`](../test/tb_tc_sram.sv.md) — 실행되는 테스트벤치
