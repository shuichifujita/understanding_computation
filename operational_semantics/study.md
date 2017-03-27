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

## 自由研究 その3
フィボナッチ数列を実装
```Ruby
def fib(n)
  if n == 0
    0
  elsif n == 1
    1
  else
    fib(n-2) + fib(n-1)
  end
end

# fib(10)
# => 55
```


```Ruby
# <<Simple>>

# cnt = 0;
# x0 = 0;
# x1 = 1;
# while (cnt < 10) {
#   x2 = x0 + x1;
#   x0 = x1;
#   x1 = x2;
#   cnt = cnt + 1;
# }

st = Sequence.new(
      Assign.new(:cnt, Number.new(1)),
      Sequence.new(
        Assign.new(:x0, Number.new(0)),
        Sequence.new(
          Assign.new(:x1, Number.new(1)),
          While.new(
            LessThan.new(Variable.new(:cnt), Number.new(10)),
            Sequence.new(
              Assign.new(:x2, Add.new(Variable.new(:x0), Variable.new(:x1))),
              Sequence.new(
                Assign.new(:x0, Variable.new(:x1)),
                Sequence.new(
                  Assign.new(:x1, Variable.new(:x2)),
                  Assign.new(:cnt, Add.new(Variable.new(:cnt), Number.new(1))))))
          )
        )
      )
    )
```

実行結果
```Ruby
# Machine.new(st, {}).run
# => <<cnt = 1; x0 = 0; x1 = 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }>>
# irb(main):067:0> Machine.new(st, {}).run
# cnt = 1; x0 = 0; x1 = 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {}
# do-nothing; x0 = 0; x1 = 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>}
# x0 = 0; x1 = 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>}
# do-nothing; x1 = 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<0>>}
# x1 = 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<0>>}
# do-nothing; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<0>>, :x1=><<1>>}
# while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<0>>, :x1=><<1>>}
# if (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<1>>, :x0=><<0>>, :x1=><<1>>}
# if (1 < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<1>>, :x0=><<0>>, :x1=><<1>>}
# if (true) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<1>>, :x0=><<0>>, :x1=><<1>>}
# x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<0>>, :x1=><<1>>}
# x2 = 0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<0>>, :x1=><<1>>}
# x2 = 0 + 1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<0>>, :x1=><<1>>}
# x2 = 1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<0>>, :x1=><<1>>}
# do-nothing; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<0>>, :x1=><<1>>, :x2=><<1>>}
# x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<0>>, :x1=><<1>>, :x2=><<1>>}
# x0 = 1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<0>>, :x1=><<1>>, :x2=><<1>>}
# do-nothing; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# x1 = 1; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# do-nothing; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# cnt = 1 + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# cnt = 2; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<1>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# do-nothing; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# if (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# if (2 < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# if (true) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# x2 = 1 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# x2 = 1 + 1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# x2 = 2; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<1>>}
# do-nothing; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<2>>}
# x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<2>>}
# x0 = 1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<2>>}
# do-nothing; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<2>>}
# x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<2>>}
# x1 = 2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<1>>, :x2=><<2>>}
# do-nothing; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# cnt = 2 + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# cnt = 3; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<2>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# do-nothing; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# if (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<3>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# if (3 < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<3>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# if (true) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<3>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# x2 = 1 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# x2 = 1 + 2; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# x2 = 3; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<1>>, :x1=><<2>>, :x2=><<2>>}
# do-nothing; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<1>>, :x1=><<2>>, :x2=><<3>>}
# x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<1>>, :x1=><<2>>, :x2=><<3>>}
# x0 = 2; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<1>>, :x1=><<2>>, :x2=><<3>>}
# do-nothing; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<2>>, :x1=><<2>>, :x2=><<3>>}
# x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<2>>, :x1=><<2>>, :x2=><<3>>}
# x1 = 3; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<2>>, :x1=><<2>>, :x2=><<3>>}
# do-nothing; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# cnt = 3 + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# cnt = 4; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<3>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# do-nothing; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# if (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<4>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# if (4 < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<4>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# if (true) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<4>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# x2 = 2 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# x2 = 2 + 3; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# x2 = 5; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<2>>, :x1=><<3>>, :x2=><<3>>}
# do-nothing; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<2>>, :x1=><<3>>, :x2=><<5>>}
# x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<2>>, :x1=><<3>>, :x2=><<5>>}
# x0 = 3; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<2>>, :x1=><<3>>, :x2=><<5>>}
# do-nothing; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<3>>, :x1=><<3>>, :x2=><<5>>}
# x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<3>>, :x1=><<3>>, :x2=><<5>>}
# x1 = 5; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<3>>, :x1=><<3>>, :x2=><<5>>}
# do-nothing; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# cnt = 4 + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# cnt = 5; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<4>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# do-nothing; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# if (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<5>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# if (5 < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<5>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# if (true) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<5>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# x2 = 3 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# x2 = 3 + 5; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# x2 = 8; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<3>>, :x1=><<5>>, :x2=><<5>>}
# do-nothing; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<3>>, :x1=><<5>>, :x2=><<8>>}
# x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<3>>, :x1=><<5>>, :x2=><<8>>}
# x0 = 5; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<3>>, :x1=><<5>>, :x2=><<8>>}
# do-nothing; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<5>>, :x1=><<5>>, :x2=><<8>>}
# x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<5>>, :x1=><<5>>, :x2=><<8>>}
# x1 = 8; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<5>>, :x1=><<5>>, :x2=><<8>>}
# do-nothing; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# cnt = 5 + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# cnt = 6; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<5>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# do-nothing; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# if (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<6>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# if (6 < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<6>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# if (true) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<6>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# x2 = 5 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# x2 = 5 + 8; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# x2 = 13; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<5>>, :x1=><<8>>, :x2=><<8>>}
# do-nothing; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<5>>, :x1=><<8>>, :x2=><<13>>}
# x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<5>>, :x1=><<8>>, :x2=><<13>>}
# x0 = 8; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<5>>, :x1=><<8>>, :x2=><<13>>}
# do-nothing; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<8>>, :x1=><<8>>, :x2=><<13>>}
# x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<8>>, :x1=><<8>>, :x2=><<13>>}
# x1 = 13; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<8>>, :x1=><<8>>, :x2=><<13>>}
# do-nothing; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# cnt = 6 + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# cnt = 7; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<6>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# do-nothing; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# if (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<7>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# if (7 < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<7>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# if (true) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<7>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# x2 = 8 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# x2 = 8 + 13; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# x2 = 21; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<8>>, :x1=><<13>>, :x2=><<13>>}
# do-nothing; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<8>>, :x1=><<13>>, :x2=><<21>>}
# x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<8>>, :x1=><<13>>, :x2=><<21>>}
# x0 = 13; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<8>>, :x1=><<13>>, :x2=><<21>>}
# do-nothing; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<13>>, :x1=><<13>>, :x2=><<21>>}
# x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<13>>, :x1=><<13>>, :x2=><<21>>}
# x1 = 21; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<13>>, :x1=><<13>>, :x2=><<21>>}
# do-nothing; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# cnt = 7 + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# cnt = 8; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<7>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# do-nothing; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# if (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<8>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# if (8 < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<8>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# if (true) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<8>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# x2 = 13 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# x2 = 13 + 21; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# x2 = 34; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<13>>, :x1=><<21>>, :x2=><<21>>}
# do-nothing; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<13>>, :x1=><<21>>, :x2=><<34>>}
# x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<13>>, :x1=><<21>>, :x2=><<34>>}
# x0 = 21; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<13>>, :x1=><<21>>, :x2=><<34>>}
# do-nothing; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<21>>, :x1=><<21>>, :x2=><<34>>}
# x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<21>>, :x1=><<21>>, :x2=><<34>>}
# x1 = 34; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<21>>, :x1=><<21>>, :x2=><<34>>}
# do-nothing; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# cnt = 8 + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# cnt = 9; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<8>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# do-nothing; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# if (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<9>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# if (9 < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<9>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# if (true) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<9>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# x2 = 21 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# x2 = 21 + 34; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# x2 = 55; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<21>>, :x1=><<34>>, :x2=><<34>>}
# do-nothing; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<21>>, :x1=><<34>>, :x2=><<55>>}
# x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<21>>, :x1=><<34>>, :x2=><<55>>}
# x0 = 34; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<21>>, :x1=><<34>>, :x2=><<55>>}
# do-nothing; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<34>>, :x1=><<34>>, :x2=><<55>>}
# x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<34>>, :x1=><<34>>, :x2=><<55>>}
# x1 = 55; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<34>>, :x1=><<34>>, :x2=><<55>>}
# do-nothing; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<34>>, :x1=><<55>>, :x2=><<55>>}
# cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<34>>, :x1=><<55>>, :x2=><<55>>}
# cnt = 9 + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<34>>, :x1=><<55>>, :x2=><<55>>}
# cnt = 10; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<9>>, :x0=><<34>>, :x1=><<55>>, :x2=><<55>>}
# do-nothing; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<10>>, :x0=><<34>>, :x1=><<55>>, :x2=><<55>>}
# while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 }, {:cnt=><<10>>, :x0=><<34>>, :x1=><<55>>, :x2=><<55>>}
# if (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<10>>, :x0=><<34>>, :x1=><<55>>, :x2=><<55>>}
# if (10 < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<10>>, :x0=><<34>>, :x1=><<55>>, :x2=><<55>>}
# if (false) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1; while (cnt < 10) { x2 = x0 + x1; x0 = x1; x1 = x2; cnt = cnt + 1 } } else { do-nothing }, {:cnt=><<10>>, :x0=><<34>>, :x1=><<55>>, :x2=><<55>>}
# do-nothing, {:cnt=><<10>>, :x0=><<34>>, :x1=><<55>>, :x2=><<55>>}
# => nil
```
