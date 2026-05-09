# pad_functional.sv

I/O 패드 기능 셀의 행동 모델입니다. Verilog 1995 게이트 프리미티브를 사용하여 구현되어 있습니다.

> **Deprecated**: FPGA 구현 시 [`src/fpga/pad_functional_xilinx.sv`](../fpga/pad_functional_xilinx.sv.md)를 사용하세요.  
> **Verilator 비호환**: `pmos`/`rpmos` 프리미티브가 Verilator에서 지원되지 않습니다. Verilator 시뮬레이션 시 `tech_cells_generic_exclude_deprecated` 타겟으로 제외해야 합니다.

## 포함 모듈

### `pad_functional_pd` — Pull-Down 패드

```
포트:
  OEN  : 출력 인에이블 (active high = 출력 비활성, Hi-Z)
  I    : 출력 데이터
  O    : 입력 데이터 (PAD 읽기)
  PEN  : 풀 인에이블 (active high = 풀 비활성)
  PAD  : 양방향 I/O 패드
```

### `pad_functional_pu` — Pull-Up 패드

`pad_functional_pd`와 동일한 포트 구조. 풀 방향만 다릅니다.

## 진리표

| OEN | I | PAD | PEN | PAD 상태 | O |
|-----|---|-----|-----|----------|---|
| 0 | 0 | - | x | 0 | 0 |
| 0 | 1 | - | x | 1 | 1 |
| 1 | x | 0 | x | - | 0 |
| 1 | x | 1 | x | - | 1 |
| 1 | x | Z | 0 | Pull (L/H) | L/H |
| 1 | x | Z | 1 | - | X |

## 구현 방식

```verilog
bufif0 (PAD, I, OEN);    // OEN=0 시 I를 PAD에 구동
buf    (O, PAD);          // PAD를 O로 읽기
bufif0 (PAD_wi, 1'b0/1'b1, PEN);  // 풀 저항 제어 신호
rpmos  (PAD, PAD_wi, 1'b0);       // 풀 저항 연결
```

## 관련 파일

- [`../fpga/pad_functional_xilinx.sv`](../fpga/pad_functional_xilinx.sv.md) — Xilinx FPGA 구현체
