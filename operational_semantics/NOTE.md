## p.20~ Small Step Semantics

### p.22 はじめの抽象構文木の構築

```Ruby
Add.new(
  Multiply.new(Number.new(1), Number.new(2)),
  Multiply.new(Number.new(3), Number.new(4))
)
```

### p.27 式の簡約の実現

```Ruby

expression = Add.new(
  Multiply.new(Number.new(1), Number.new(2)),
  Multiply.new(Number.new(3), Number.new(4))
)

expression.reducible?
#...

```


### p.28 仮想機械の実行

```Ruby
Machine.new(
  Add.new(
    Multiply.new(Number.new(1), Number.new(2)),
    Multiply.new(Number.new(3), Number.new(4))
  )
).run
```


## p.29 Boolean, LessThanの実装後のスニペット

```Ruby
Machine.new(
  LessThan.new(
    Number.new(5),
    Add.new(Number.new(2), Number.new(2))
  )
).run
```

## p.30 環境を入れた機械

```Ruby
Machine.new(
  Add.new(Variable.new(:x), Variable.new(:y)),
  { x: Number.new(3), y: Number.new(4) } # environment
).run
```

## p.34 Assignの挙動確認

```Ruby
statement = Assign.new(:x, Add.new(Variable.new(:x), Number.new(1)))
environment = { x: Number.new(2) }
```

## p.35 文の扱えるMachine
```Ruby
Machine.new(
  Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))),
  { x: Number.new(2) }
).run

# if (x) { y = 1 } else { y = 2 }, {:x=>«true»}
# if (true) { y = 1 } else { y = 2 }, {:x=>«true»} y = 1, {:x=>«true»}
# do-nothing, {:x=>«true», :y=>«1»}
# => nil
```

## p.36 Ifの実行
```Ruby
Machine.new(
  If.new(Variable.new(:x),
    Assign.new(:y, Number.new(1)),
    Assign.new(:y, Number.new(2))
  ),
  { x: Boolean.new(true) }
).run
```

`else` 節のないようなパターン

```Ruby
Machine.new(
  If.new(Variable.new(:x),
    Assign.new(:y, Number.new(1)),
    DoNothing.new
  ),
  { x: Boolean.new(false) }
).run

# if (x) { y = 1 } else { do-nothing }, {:x=>«false»}
# if (false) { y = 1 } else { do-nothing }, {:x=>«false»} do-nothing, {:x=>«false»}
# => nil
```

## p.37 Sequence
```Ruby
Machine.new(
  Sequence.new(
    Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
    Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
  ),
  {}
).run

# x = 1 + 1; y = x + 3, {}
# x = 2; y = x + 3, {}
# do-nothing; y = x + 3, {:x=><<2>>}
# y = x + 3, {:x=><<2>>}
# y = 2 + 3, {:x=><<2>>}
# y = 5, {:x=><<2>>}
# do-nothing, {:x=><<2>>, :y=><<5>>}
# => nil
```
