# compile_vltor.sh

Verilator 시뮬레이션을 위한 소스 파일 목록(flist)을 생성하는 스크립트입니다. QuestaSim의 [`compile_vsim.sh`](compile_vsim.sh.md)에 대응합니다.

## 동작

1. `bender checkout` — `Bender.yml`에 정의된 의존성(`common_verification` 등)을 체크아웃합니다.
2. `bender script flist` — 지정된 타겟 조건으로 소스 파일 목록을 생성해 `compile_vltor.flist`로 저장합니다.

## 사용된 Bender 타겟

| 타겟 | 목적 |
|------|------|
| `test` | 테스트벤치 파일(`tb_tc_sram.sv`) 포함 |
| `rtl` | RTL 소스 파일 포함 |
| `verilator` | Verilator 호환 시뮬레이션 파일 포함 (`clk_rst_gen.sv` 등) |
| `tech_cells_generic_exclude_deprecated` | Verilator 미지원 프리미티브(`pmos` 등)가 있는 deprecated 파일 제외 |

## 출력

- `{프로젝트루트}/compile_vltor.flist` — 각 줄에 소스 파일 경로가 나열된 파일 목록 (`.gitignore`에 의해 추적 제외)

## 사용법

```bash
bash scripts/compile_vltor.sh
```

`run_vltor.sh` 실행 전에 반드시 먼저 실행해야 합니다.

## 관련 파일

- [`run_vltor.sh`](run_vltor.sh.md) — 생성된 flist를 사용하여 Verilator 시뮬레이션 실행
- [`compile_vsim.sh`](compile_vsim.sh.md) — QuestaSim 대응 스크립트
