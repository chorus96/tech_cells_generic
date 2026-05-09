# pad_functional_xilinx.sv

Xilinx FPGA용 I/O 패드 기능 셀입니다. [`src/deprecated/pad_functional.sv`](../deprecated/pad_functional.sv.md)의 FPGA 구현체로, Xilinx `IOBUF` 프리미티브를 사용합니다.

## 블록 다이어그램

```mermaid
flowchart LR
    subgraph PD["pad_functional_pd\n(* PULLDOWN = YES *)"]
        OEN_D(OEN) --> IOBUF_D["Xilinx\nIOBUF"]
        I_D(I) --> IOBUF_D
        IOBUF_D --> O_D(O)
        IOBUF_D <-->|"양방향"| PAD_D(PAD)
        PEN_D(PEN) -->|"미사용\n(속성으로 처리)"| IOBUF_D
    end

    subgraph PU["pad_functional_pu\n(* PULLUP = YES *)"]
        OEN_U(OEN) --> IOBUF_U["Xilinx\nIOBUF"]
        I_U(I) --> IOBUF_U
        IOBUF_U --> O_U(O)
        IOBUF_U <-->|"양방향"| PAD_U(PAD)
        PEN_U(PEN) -->|"미사용"| IOBUF_U
    end
```

## IOBUF 동작 원리

```mermaid
flowchart LR
    subgraph IOBUF["Xilinx IOBUF"]
        T(T=OEN) -->|"0: 출력 구동\n1: Hi-Z"| OBUF["출력 버퍼"]
        I_IN(I) --> OBUF
        OBUF --> IO(IO=PAD)
        IO --> IBUF["입력 버퍼"]
        IBUF --> O_OUT(O)
    end
```

| OEN(T) | I | PAD 외부 값 | O | PAD |
|--------|---|------------|---|-----|
| 0 | 0 | - | 0 | **0** (구동) |
| 0 | 1 | - | 1 | **1** (구동) |
| 1 | x | 0 | 0 | Hi-Z (풀 적용) |
| 1 | x | 1 | 1 | Hi-Z (풀 적용) |
| 1 | x | Z | 0(PD)/1(PU) | **풀 저항** |

## 풀 저항 구현 방식

```mermaid
flowchart TD
    subgraph PD2["pad_functional_pd"]
        ATTR_D["(* PULLDOWN = YES *)\n속성으로 풀다운 설정"]
        IOBUF2_D["IOBUF"]
        ATTR_D --> IOBUF2_D
    end

    subgraph PU2["pad_functional_pu"]
        ATTR_U["(* PULLUP = YES *)\n속성으로 풀업 설정"]
        IOBUF2_U["IOBUF"]
        ATTR_U --> IOBUF2_U
    end
```

RTL 행동 모델은 `rpmos` 프리미티브로 풀 저항을 구현하지만, FPGA 버전은 Xilinx 합성 속성(`PULLDOWN`/`PULLUP`)으로 처리합니다.

## RTL 행동 모델과의 차이

| 항목 | RTL (`pad_functional.sv`) | Xilinx (`pad_functional_xilinx.sv`) |
|------|--------------------------|-------------------------------------|
| 풀 저항 | `rpmos` 게이트 프리미티브 | `(* PULLDOWN/PULLUP = "YES" *)` 속성 |
| 출력 | `bufif0` 프리미티브 | `IOBUF.T` 제어 |
| Verilator | ❌ 미지원 (`pmos`) | ✅ 지원 가능 |

## 관련 파일

- [`../deprecated/pad_functional.sv`](../deprecated/pad_functional.sv.md) — RTL 행동 모델
- [`tc_clk_xilinx.sv`](tc_clk_xilinx.sv.md) — Xilinx 클럭 셀
