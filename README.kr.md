# 범용 기술 셀 (셀 라이브러리 API)

관리자: Philippe Sauter <phsauter@iis.ee.ethz.ch>

이 저장소는 SRAM, 클럭 게이팅 셀, 전력 관리 셀 등 기술 관련 셀을 포함합니다. 여기에 수록된 내용은 다음과 같습니다:

- **행동 모델(Behavioral)**: RTL 시뮬레이션 전용입니다.
- **FPGA**: FPGA 구현용입니다. 현재는 Xilinx FPGA만 지원합니다. Altera 또는 다른 디바이스에 대한 패치는 환영합니다.

기술별 파일에서 올바른 구동 강도(drive strength)를 갖는 셀을 포함하는 것은 사용자의 몫입니다. 프론트엔드에서는 더 이상 이러한 가정을 하지 않습니다.

> 이 레이어는 새로운 기술마다 재구현해야 하므로 최대한 간결하게 유지하세요!

## 셀 목록

새로운 기술(미지원 FPGA 또는 ASIC 기술)을 시작하려면 이 저장소의 셀에 대한 구현체를 제공해주세요.

### 클럭 셀

클럭 셀은 일반적으로 글리치가 발생하지 않도록 세심하게 설계된 셀입니다. 따라서 ASIC 설계에서는 수동으로 인스턴스화해야 합니다. 모든 클럭 셀은 `tc_clk.sv`에서 찾을 수 있습니다.

| 이름 | 설명 | 상태 | Xilinx |
|------|------|------|--------|
| `tc_clk_and2` | 클럭 AND 게이트 | 활성 | :white_check_mark: |
| `tc_clk_buffer` | 클럭 버퍼 | 활성 | :white_check_mark: |
| `tc_clk_gating` | 통합 클럭 게이팅 셀 | 활성 | :white_check_mark: |
| `tc_clk_inverter` | 클럭 인버터 | 활성 | :white_check_mark: |
| `tc_clk_mux2` | 2-입력 클럭 멀티플렉서 | 활성 | :white_check_mark: |
| `tc_clk_xor2` | 클럭 XOR | 활성 | :white_check_mark: |
| `tc_clk_or2` | 클럭 OR | 활성 | :white_check_mark: |
| `tc_clk_delay` | 프로그래머블 클럭 딜레이 | 활성 | |

### 메모리

| 이름 | 설명 | 상태 | Xilinx |
|------|------|------|--------|
| `tc_sram` | 설정 가능한 SRAM | 활성 | :white_check_mark: |

### 전력 셀

전력 셀은 주로 고급 파워 게이팅 기능에 사용되며, 현재 공개된 IP에서는 사용되지 않습니다. 그러나 자유롭게 재사용하셔도 됩니다. 모든 전력 셀은 `tc_pwr.sv`에서 찾을 수 있습니다.

| 이름 | 설명 | 상태 |
|------|------|------|
| `tc_pwr_level_shifter_in` | 레벨 시프터 | 활성 |
| `tc_pwr_level_shifter_in_clamp_lo` | `1'b0` 클램프 레벨 시프터 | 활성 |
| `tc_pwr_level_shifter_in_clamp_hi` | `1'b1` 클램프 레벨 시프터 | 활성 |
| `tc_pwr_level_shifter_out` | 레벨 시프터 | 활성 |
| `tc_pwr_level_shifter_out_clamp_lo` | `1'b0` 클램프 레벨 시프터 | 활성 |
| `tc_pwr_level_shifter_out_clamp_hi` | `1'b1` 클램프 레벨 시프터 | 활성 |
| `tc_pwr_power_gating` | 제어 및 상태 핀을 갖는 파워 게이트 | 활성 |
| `tc_pwr_isolation_lo` | `1'b0` 아이솔레이션 셀 | 활성 |
| `tc_pwr_isolation_hi` | `1'b1` 아이솔레이션 셀 | 활성 |
