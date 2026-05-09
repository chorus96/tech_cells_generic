# tc_sram_impl.sv

`tc_sram`에 구현체 관련 입출력 포트(`impl_i`, `impl_o`)를 추가한 래퍼 모듈입니다. 공정별 SRAM 매크로가 pseudo-static 제어 신호를 필요로 할 때 `tc_sram` 대신 직접 교체하여 사용합니다.

## 모듈: `tc_sram_impl`

### 추가 파라미터 (`tc_sram` 대비)

| 파라미터 | 기본값 | 설명 |
|----------|--------|------|
| `impl_in_t` | `logic` | 구현체 입력 신호 타입 |
| `impl_out_t` | `logic` | 구현체 출력 신호 타입 |
| `ImplOutSim` | `'X` | 행동 시뮬레이션에서 `impl_o`에 구동할 정적 값 |

### 추가 포트

| 포트 | 방향 | 설명 |
|------|------|------|
| `impl_i` | input | 구현체 관련 입력 (행동 모델에서 무시됨) |
| `impl_o` | output | 구현체 관련 출력 (`ImplOutSim` 값으로 정적 구동) |

나머지 포트는 [`tc_sram`](tc_sram.sv.md)과 동일합니다.

### 동작

행동 시뮬레이션에서 `impl_i`는 무시되고, `impl_o`는 `ImplOutSim` 파라미터 값으로 정적 구동됩니다. 내부적으로 `tc_sram`을 인스턴스화하여 실제 메모리 동작을 위임합니다.

```
impl_o = ImplOutSim  (정적 할당)
내부: tc_sram 인스턴스 → 모든 메모리 포트 그대로 연결
```

### 사용 목적

공정별 SRAM 매크로 교체 시 이 모듈을 사용하면 `impl_i`/`impl_o`를 통해 추가적인 매크로 제어 신호를 연결할 수 있습니다. 행동 모델은 이 신호들을 무시하여 시뮬레이션 호환성을 유지합니다.

## 관련 파일

- [`tc_sram.sv`](tc_sram.sv.md) — 내부적으로 인스턴스화하는 기본 SRAM 모듈
