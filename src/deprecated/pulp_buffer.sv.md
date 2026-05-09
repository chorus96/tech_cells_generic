# pulp_buffer.sv

단순 신호 버퍼 셀의 행동 모델입니다.

> **Deprecated**: 신규 설계에서는 표준 버퍼 셀이나 직접 와이어 연결을 사용하세요.

## 모듈: `pulp_buffer`

### 포트

| 포트 | 방향 | 설명 |
|------|------|------|
| `in_i` | input | 입력 신호 |
| `out_o` | output | 출력 신호 |

### 동작

```verilog
assign out_o = in_i;
```

단순 feedthrough 버퍼입니다. ASIC 구현 시 적절한 드라이브 강도를 가진 버퍼 셀로 대체됩니다.
