# tc_sram_xilinx.sv

Xilinx XPM(Xilinx Parameterized Macro)을 사용한 `tc_sram` FPGA 구현체입니다. `tc_sram`과 동일한 인터페이스를 제공하며, Vivado에서 FPGA 합성 시 이 파일이 사용됩니다.

## 모듈: `tc_sram`

`tc_sram.sv`와 동일한 파라미터 및 포트를 가집니다. 파라미터 상세는 [`src/rtl/tc_sram.sv`](../rtl/tc_sram.sv.md)를 참조하세요.

### FPGA 전용 추가 파라미터

| 파라미터 | 기본값 | 설명 |
|----------|--------|------|
| `FPGAImplKey` | `"auto"` | XPM 메모리 프리미티브 타입 (`"auto"`, `"block"`, `"ultra"`, `"distributed"`) |

## XPM 매핑

### `NumPorts == 1` → `xpm_memory_spram` (Single Port RAM)

| XPM 파라미터 | 값 |
|-------------|-----|
| `MEMORY_PRIMITIVE` | `FPGAImplKey` |
| `MEMORY_SIZE` | `NumWords × DataWidthAligned` (비트 단위) |
| `READ_LATENCY_A` | `Latency` |
| `BYTE_WRITE_WIDTH_A` | 8 (XPM은 8비트 바이트만 지원) |

### `NumPorts == 2` → `xpm_memory_tdpram` (True Dual Port RAM)

동일 클럭(`common_clock`)을 포트 A/B에 공유합니다.

### `NumPorts >= 3` → `$fatal`

## 바이트 폭 정렬 (ByteWidth → 8비트 정렬)

XPM은 8비트 바이트 단위만 지원합니다. `ByteWidth`가 8의 배수가 아닐 경우 상위 비트로 패딩하여 정렬합니다:

```
BytesPerByte     = ceil(ByteWidth / 8)
ByteWidthAligned = BytesPerByte × 8
DataWidthAligned = ByteWidthAligned × BeWidth
```

## 제약사항

- `SimInit`은 `"zeros"`로 고정됩니다 (XPM 초기화 항상 0).
- Vivado에서 XPM 인식을 위해 다음 중 하나가 필요합니다:
  ```tcl
  auto_detect_xpm
  # 또는
  set_property XPM_LIBRARIES XPM_MEMORY [current_project]
  ```

## 관련 파일

- [`../rtl/tc_sram.sv`](../rtl/tc_sram.sv.md) — RTL 행동 모델
- [`tc_clk_xilinx.sv`](tc_clk_xilinx.sv.md) — Xilinx 클럭 셀
- [`../../scripts/vivado/run_xsim.tcl`](../../scripts/vivado/run_xsim.tcl.md) — Vivado 시뮬레이션 스크립트
