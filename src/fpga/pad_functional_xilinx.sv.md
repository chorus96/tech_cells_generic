# pad_functional_xilinx.sv

Xilinx FPGA용 I/O 패드 기능 셀입니다. [`src/deprecated/pad_functional.sv`](../deprecated/pad_functional.sv.md)의 FPGA 구현체로, Xilinx `IOBUF` 프리미티브를 사용합니다.

## 포함 모듈

### `pad_functional_pd` — Pull-Down 패드

Xilinx `IOBUF`에 `(* PULLDOWN = "YES" *)` 속성을 적용합니다.

```
포트:
  OEN  : 출력 인에이블 (active high = Hi-Z)
  I    : 출력 데이터
  O    : 입력 데이터
  PEN  : 풀 인에이블 (사용되지 않음, PULLDOWN 속성으로 대체)
  PAD  : 양방향 I/O 패드
```

### `pad_functional_pu` — Pull-Up 패드

Xilinx `IOBUF`에 `(* PULLUP = "YES" *)` 속성을 적용합니다. 포트 구성은 `pad_functional_pd`와 동일합니다.

## 행동 진리표

| OEN | I | PAD (외부) | O |
|-----|---|-----------|---|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 1 |
| 1 | x | 0 | 0 |
| 1 | x | 1 | 1 |
| 1 | x | Z (PD) | 0 |
| 1 | x | Z (PU) | 1 |

## RTL 행동 모델과의 차이

행동 모델([`pad_functional.sv`](../deprecated/pad_functional.sv.md))은 Verilog 1995 게이트 프리미티브(`bufif0`, `rpmos`)를 사용하여 Verilator에서 지원되지 않습니다. 이 FPGA 버전은 Xilinx `IOBUF` 프리미티브로 대체합니다.

## 관련 파일

- [`../deprecated/pad_functional.sv`](../deprecated/pad_functional.sv.md) — RTL 행동 모델 (시뮬레이션 전용)
