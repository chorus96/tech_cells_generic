# compile_vsim.sh

QuestaSim(ModelSim) 시뮬레이션을 위해 소스 파일을 컴파일하는 스크립트입니다.

## 동작

1. `bender script vsim` — Bender가 QuestaSim용 TCL 컴파일 스크립트(`compile.tcl`)를 생성합니다.
2. `echo 'return 0'` — TCL 스크립트 끝에 종료 코드를 추가합니다.
3. `vsim -c -do` — QuestaSim을 비대화형 모드로 실행하여 TCL 스크립트를 소싱하고 컴파일합니다.

## 사용된 Bender 옵션

| 옵션 | 설명 |
|------|------|
| `-t test` | 테스트벤치 파일 포함 |
| `-t rtl` | RTL 소스 파일 포함 |
| `--vlog-arg="-svinputport=compat"` | SystemVerilog 입력 포트 호환 모드 |
| `--vlog-arg="-override_timescale 1ns/1ps"` | 타임스케일을 1ns/1ps로 강제 설정 |

## 출력

- `compile.tcl` — QuestaSim용 TCL 컴파일 스크립트 (중간 생성물)
- QuestaSim 라이브러리 (work 디렉토리)

## 사용법

```bash
bash scripts/compile_vsim.sh
```

`run_vsim.sh` 실행 전에 반드시 먼저 실행해야 합니다.

## 관련 파일

- [`run_vsim.sh`](run_vsim.sh.md) — 컴파일된 라이브러리로 시뮬레이션 실행
- [`compile_vltor.sh`](compile_vltor.sh.md) — Verilator 대응 스크립트
