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

## p.44 Sequenceの挙動確認

```ruby
statement = Sequence.new(
  Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
  Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
)
# => «x = 1 + 1; y = x + 3»
statement.evaluate({})
# => {:x=>«2», :y=>«5»}
```

# p.45 Whileの挙動確認

```Ruby
statement = While.new(
  LessThan.new(Variable.new(:x), Number.new(5)),
  Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
)
# => «while (x < 5) { x = x * 3 }»
statement.evaluate({ x: Number.new(1) })
# => {:x=>«9»}
```
