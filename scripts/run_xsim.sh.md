# run_xsim.sh

Xilinx Vivado의 xsim 시뮬레이터로 시뮬레이션을 실행하는 스크립트입니다.

## 동작

1. `bender script vivado-sim -t test` — Vivado용 소스 추가 TCL 스크립트(`vivado/add_sources.tcl`)를 생성합니다.
2. `vivado-{버전} vivado -mode batch -source run_xsim.tcl` — Vivado를 배치 모드로 실행하여 `run_xsim.tcl`을 소싱합니다.

## 설정

| 변수 | 값 | 설명 |
|------|----|------|
| `VIVADO_VER` | `2018.2` | 사용할 Vivado 버전 |

## 의존 파일

- [`vivado/run_xsim.tcl`](vivado/run_xsim.tcl.md) — Vivado 프로젝트 생성 및 시뮬레이션 실행 TCL 스크립트
- `vivado/add_sources.tcl` — Bender가 생성하는 소스 추가 스크립트 (`.gitignore`에 의해 추적 제외)

## 사용법

```bash
bash scripts/run_xsim.sh
```

## 관련 파일

- [`run_vsim.sh`](run_vsim.sh.md) — QuestaSim 대응 스크립트
- [`run_vltor.sh`](run_vltor.sh.md) — Verilator 대응 스크립트
