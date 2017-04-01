# p.41~ big step semantics

## p.43 初めのBigStepの挙動確認

```Ruby
Number.new(23).evaluate({})
# => «23»

Variable.new(:x).evaluate({ x: Number.new(23) })
# => «23»
LessThan.new(
  Add.new(Variable.new(:x), Number.new(2)),
  Variable.new(:y)
).evaluate({ x: Number.new(2), y: Number.new(5) })
# => «true»
```
