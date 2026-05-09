# run_xsim.sh

Xilinx Vivado의 xsim 시뮬레이터로 시뮬레이션을 실행하는 스크립트입니다.

## 실행 흐름

```mermaid
flowchart TD
    START([./scripts/run_xsim.sh]) --> BENDER["bender script vivado-sim -t test\n→ vivado/add_sources.tcl 생성"]
    BENDER --> TCL_GEN["add_sources.tcl\n(소스 파일 추가 명령)"]
    TCL_GEN --> VIVADO["vivado-2018.2 vivado\n-mode batch\n-source run_xsim.tcl"]
    VIVADO --> PROJ["Vivado 프로젝트 생성\ntc_generic_sim"]
    PROJ --> SIM1["1-포트 xsim\nNumPorts=32'd1"]
    SIM1 --> SIM2["2-포트 xsim\nNumPorts=32'd2"]
    SIM2 --> END([완료])
```

## 스크립트 간 관계

```mermaid
flowchart LR
    RUN_SH["run_xsim.sh"]
    BENDER_CMD["bender script\nvivado-sim -t test"]
    ADD_SRC["vivado/add_sources.tcl\n(자동 생성, gitignore)"]
    RUN_TCL["vivado/run_xsim.tcl\n(수동 관리)"]
    VIVADO_BIN["vivado-2018.2"]

    RUN_SH --> BENDER_CMD --> ADD_SRC
    RUN_SH --> VIVADO_BIN
    VIVADO_BIN --> ADD_SRC
    VIVADO_BIN --> RUN_TCL
```

## 설정

| 변수 | 값 | 설명 |
|------|----|------|
| `VIVADO_VER` | `2018.2` | 사용할 Vivado 버전 |

## 의존 파일

- [`vivado/run_xsim.tcl`](vivado/run_xsim.tcl.md) — Vivado 프로젝트 생성 및 시뮬레이션 TCL
- `vivado/add_sources.tcl` — Bender 생성 (`.gitignore` 적용)

## 사용법

```bash
# Vivado 2018.2가 PATH에 있어야 함
bash scripts/run_xsim.sh
```

## 관련 파일

- [`run_vsim.sh`](run_vsim.sh.md) — QuestaSim 대응 스크립트
- [`run_vltor.sh`](run_vltor.sh.md) — Verilator 대응 스크립트
