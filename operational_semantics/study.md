## 自由研究 その1
And, Orの実装

### Andの簡約規則
* left, right のexpressionをとる
* left がreduce可能ならreduceし、新しいAndを返す. `And(left.reduce, right)`
* left がreduce不可能で、rightがreduce可能なら、rightをreduceし、新しいAndを返す `And(left, right.reduce)`
* `(left == Boolean.new(true)) && (right == Boolean.new(true))` なら `Boolean.new(true)` を返し、そうでなければ `Boolean.new(false)` を返す。

### Orの簡約規則
Andの演算子を `||` にかえる。


## 自由研究 その2
線分の下か？

```
点 (x_1, y_1) = (2, 5)が与えられた時、
直線 y_2 = 3x_2 + 2
より 上なら0 下なら1
```

```Ruby(Simple)
st = Sequence.new(
      Assign.new(:x1, Number.new(2)),
      Sequence.new(
        Assign.new(:y1, Number.new(5)),
        Sequence.new(
          Assign.new(
            :y2,
             Add.new(
               Multiply.new(Number.new(3), Variable.new(:x1)),
               Number.new(2)
             )
          ),
          If.new(
            LessThan.new(Variable.new(:y2), Variable.new(:y1)),
            Number.new(0),
            Number.new(1)
          )
        )
      )
    )
env = {}
Machine.new(st, env).run

# x1 = 2; y1 = 5; y2 = 3 * x1 + 2; if (y2 < y1) { 0 } else { 1 }, {}
# do-nothing; y1 = 5; y2 = 3 * x1 + 2; if (y2 < y1) { 0 } else { 1 }, {:x1=><<2>>}
# y1 = 5; y2 = 3 * x1 + 2; if (y2 < y1) { 0 } else { 1 }, {:x1=><<2>>}
# do-nothing; y2 = 3 * x1 + 2; if (y2 < y1) { 0 } else { 1 }, {:x1=><<2>>, :y1=><<5>>}
# y2 = 3 * x1 + 2; if (y2 < y1) { 0 } else { 1 }, {:x1=><<2>>, :y1=><<5>>}
# y2 = 3 * 2 + 2; if (y2 < y1) { 0 } else { 1 }, {:x1=><<2>>, :y1=><<5>>}
# y2 = 6 + 2; if (y2 < y1) { 0 } else { 1 }, {:x1=><<2>>, :y1=><<5>>}
# y2 = 8; if (y2 < y1) { 0 } else { 1 }, {:x1=><<2>>, :y1=><<5>>}
# do-nothing; if (y2 < y1) { 0 } else { 1 }, {:x1=><<2>>, :y1=><<5>>, :y2=><<8>>}
# if (y2 < y1) { 0 } else { 1 }, {:x1=><<2>>, :y1=><<5>>, :y2=><<8>>}
# if (8 < y1) { 0 } else { 1 }, {:x1=><<2>>, :y1=><<5>>, :y2=><<8>>}
# if (8 < 5) { 0 } else { 1 }, {:x1=><<2>>, :y1=><<5>>, :y2=><<8>>}
# if (false) { 0 } else { 1 }, {:x1=><<2>>, :y1=><<5>>, :y2=><<8>>}
# 1, {:x1=><<2>>, :y1=><<5>>, :y2=><<8>>}
# => nil
```

