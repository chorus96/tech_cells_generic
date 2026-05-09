# compile_vsim.sh

QuestaSim(ModelSim) 시뮬레이션을 위해 소스 파일을 컴파일하는 스크립트입니다.

## 실행 흐름

```mermaid
flowchart TD
    START([./scripts/compile_vsim.sh]) --> BENDER["bender script vsim\n-t test -t rtl\n--vlog-arg=...\n> compile.tcl"]
    BENDER --> TCL["compile.tcl 생성\n(TCL 컴파일 스크립트)"]
    TCL --> ECHO["echo 'return 0' >> compile.tcl\n(TCL 종료 코드 추가)"]
    ECHO --> VSIM["vsim -c\n-do 'exit -code [source compile.tcl]'"]
    VSIM --> LIB["work/ 라이브러리\n(컴파일된 모듈)"]
    LIB --> END([완료])
```

## 생성되는 compile.tcl 구조

```mermaid
flowchart LR
    subgraph TCL_CONTENT["compile.tcl (bender 생성)"]
        V1["vlog +incdir+... \\\n  src/rtl/tc_sram.sv"]
        V2["vlog +incdir+... \\\n  src/rtl/tc_clk.sv"]
        VN["vlog ... \\\n  test/tb_tc_sram.sv"]
        RET["return 0"]
        V1 --> V2 --> VN --> RET
    end
```

## 사용된 Bender/QuestaSim 옵션

| 옵션 | 설명 |
|------|------|
| `-t test` | 테스트벤치 파일(`tb_tc_sram.sv`) 포함 |
| `-t rtl` | RTL 소스 파일 포함 |
| `--vlog-arg="-svinputport=compat"` | SV 입력 포트 호환 모드 (암묵적 포트 방향) |
| `--vlog-arg="-override_timescale 1ns/1ps"` | 모든 파일에 타임스케일 강제 설정 |
| `vsim -c` | 비대화형(command-line) 모드로 vsim 실행 |

## vsim과 Verilator 컴파일 비교

```mermaid
flowchart LR
    subgraph VSIM_FLOW["QuestaSim 흐름"]
        CV["compile_vsim.sh\n→ compile.tcl\n→ work/ 라이브러리"]
        RV["run_vsim.sh\n→ vsim -G파라미터\n(런타임 파라미터)"]
        CV --> RV
    end

    subgraph VLTOR_FLOW["Verilator 흐름"]
        CVL["compile_vltor.sh\n→ flist 파일"]
        RVL["run_vltor.sh\n→ verilator -G파라미터\n(컴파일 타임 파라미터)"]
        CVL --> RVL
    end
```

핵심 차이: vsim은 런타임 파라미터 오버라이드가 가능하지만, Verilator는 파라미터별로 재컴파일이 필요합니다.

## 출력

- `compile.tcl` — QuestaSim용 TCL 컴파일 스크립트 (중간 생성물, gitignore 미지정)
- `work/` — QuestaSim 컴파일 라이브러리 디렉토리

## 사용법

```bash
bash scripts/compile_vsim.sh   # 컴파일 (최초 1회 또는 소스 변경 시)
bash scripts/run_vsim.sh       # 시뮬레이션 실행
```

## 관련 파일

- [`run_vsim.sh`](run_vsim.sh.md) — 컴파일된 라이브러리로 시뮬레이션 실행
- [`compile_vltor.sh`](compile_vltor.sh.md) — Verilator 대응 스크립트
