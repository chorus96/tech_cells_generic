# run_vltor.sh

Verilator로 `tb_tc_sram` 테스트벤치를 다양한 파라미터 조합으로 컴파일하고 실행하는 스크립트입니다. QuestaSim의 [`run_vsim.sh`](run_vsim.sh.md)에 대응합니다.

## 전체 실행 흐름

```mermaid
flowchart TD
    START([./scripts/run_vltor.sh]) --> CHK{"compile_vltor.flist\n존재 여부"}
    CHK -->|"없음"| ERR["오류 종료\n(compile_vltor.sh 먼저 실행)"]
    CHK -->|"있음"| LOOP["파라미터 5중 루프\nNumPorts × Latency × NumWords\n× DataWidth × ByteWidth"]

    LOOP --> MKDIR["mkdir -p\nwork-vltor/P{N}_L{N}_W{N}_D{N}_B{N}/"]
    MKDIR --> VER["verilator\n--sv --binary --timing --assert\n-G파라미터 ... -f flist"]
    VER --> BIN["Vtb_tc_sram\n(실행 파일 생성)"]
    BIN --> RUN["./Vtb_tc_sram\n시뮬레이션 실행"]
    RUN --> LOG["sim.log 저장"]
    LOG --> GREP{"grep 'errors: 0'"}
    GREP -->|"발견"| PASS["PASS ✅"]
    GREP -->|"미발견"| FAIL["FAIL ❌\n(스크립트 중단)"]
    PASS --> LOOP
    LOOP -->|"162개 완료"| END([모든 테스트 통과])
```

## 빌드 디렉토리 구조

```mermaid
flowchart LR
    ROOT["work-vltor/"]
    D1["P1_L0_W1_D1_B1/\n  compile.log\n  Vtb_tc_sram\n  sim.log"]
    D2["P1_L0_W1_D1_B8/\n  ..."]
    DN["P2_L2_W1024_D64_B9/\n  ..."]

    ROOT --> D1 & D2 & DN
```

각 파라미터 조합마다 독립된 빌드/실행 디렉토리를 생성합니다 (총 162개).

## 파라미터 스윕

```mermaid
flowchart TD
    P["NumPorts: 1, 2"]
    L["Latency: 0, 1, 2"]
    W["NumWords: 1, 420, 1024"]
    D["DataWidth: 1, 42, 64"]
    B["ByteWidth: 1, 8, 9"]
    TOTAL["총 2×3×3×3×3 = 162 조합"]

    P --> L --> W --> D --> B --> TOTAL
```

## Verilator 컴파일 플래그

| 플래그 | 설명 |
|--------|------|
| `--sv` | SystemVerilog 모드 |
| `--binary` | C++ 생성 + 컴파일 + 링크 한 번에 처리 |
| `--timing` | `#delay`, `fork...join_none`, `wait` 등 타이밍 구문 지원 |
| `--assert` | SystemVerilog assertion 활성화 |
| `--timescale 1ns/1ps` | 타임스케일 (테스트벤치 `CyclTime=10ns` 등 처리) |
| `-Wno-WIDTHTRUNC` | 비트 폭 축소 경고 억제 |
| `-Wno-WIDTHEXPAND` | 비트 폭 확장 경고 억제 |
| `-Wno-UNSIGNED` | 상수 비부호 비교 경고 억제 |
| `-Wno-INITIALDLY` | initial 블록 내 비블로킹 딜레이 경고 억제 |
| `-Wno-ASCRANGE` | 상행 범위 선언 경고 억제 (`NumWords=1` 시 발생) |
| `-GParam=value` | 컴파일 타임 파라미터 오버라이드 |
| `-f flist` | 소스 파일 목록 지정 |

## `$stop()` 처리 방식

```mermaid
flowchart LR
    SIM["Vtb_tc_sram 실행"] --> STOP["$stop() 호출\n→ abort() 신호"]
    STOP -->|"|| true\n(종료 코드 무시)"| LOG2["sim.log 저장"]
    LOG2 --> GREP2["grep 'errors: 0'"]
    GREP2 -->|"발견"| PASS2["PASS"]
```

## 환경 변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `VERILATOR` | `verilator` | 사용할 Verilator 실행 파일 경로 |

## 사용법

```bash
bash scripts/compile_vltor.sh   # flist 생성 (최초 1회)
bash scripts/run_vltor.sh       # 전체 162개 조합 시뮬레이션
# 특정 파라미터만 테스트
VERILATOR=/path/to/verilator bash scripts/run_vltor.sh
```

## 관련 파일

- [`compile_vltor.sh`](compile_vltor.sh.md) — flist 생성 (사전 실행 필요)
- [`run_vsim.sh`](run_vsim.sh.md) — QuestaSim 대응 스크립트
- [`../test/tb_tc_sram.sv`](../test/tb_tc_sram.sv.md) — 실행되는 테스트벤치
