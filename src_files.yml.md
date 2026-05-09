# src_files.yml

FuseSoC 스타일의 소스 파일 목록 파일입니다. Bender 도입 이전의 레거시 형식으로, 파일 그룹별로 합성 제외 플래그와 타겟을 정의합니다.

## 그룹 정의

### `tech_cells_rtl`

- **플래그**: `skip_synthesis` (합성 제외, 시뮬레이션 전용)
- **파일**:
  - `src/deprecated/cluster_clk_cells.sv`
  - `src/deprecated/cluster_pwr_cells.sv`
  - `src/deprecated/generic_memory.sv`
  - `src/deprecated/generic_rom.sv`
  - `src/deprecated/pad_functional.sv`
  - `src/deprecated/pulp_buffer.sv`
  - `src/deprecated/pulp_clk_cells.sv`
  - `src/deprecated/pulp_pwr_cells.sv`
  - `src/rtl/tc_clk.sv`
  - `src/rtl/tc_sram.sv`
  - `src/tc_pwr.sv`

### `tech_cells_rtl_synth`

- **플래그**: 없음 (합성 포함)
- **파일**:
  - `src/deprecated/pulp_clock_gating_async.sv`

### `tech_cells_fpga`

- **타겟**: `xilinx`
- **파일**:
  - `src/deprecated/cluster_clk_cells_xilinx.sv`
  - `src/deprecated/cluster_pwr_cells.sv`
  - `src/deprecated/pulp_clk_cells_xilinx.sv`
  - `src/deprecated/pulp_pwr_cells.sv`
  - `src/deprecated/pulp_buffer.sv`
  - `src/fpga/tc_clk_xilinx.sv`
  - `src/fpga/tc_sram_xilinx.sv`
  - `src/tc_pwr.sv`

## 비고

현재 프로젝트의 주 의존성 관리는 [`Bender.yml`](Bender.yml.md)을 사용합니다. 이 파일은 하위 호환성을 위해 유지됩니다.
