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

## p.31 代入

```ruby
statement = Assign.new(:x, Multiply.new(Number.new(3), Number.new(4)))
environment = { x: Number.new(2) }

statement, environment = statement.reduce(environment)
```

## p.34 文の扱える仮想機械

```ruby
# 現在の機械の削除
Object.send(:remove_const, :Machine)

# 新たな機会の作成はexpressionsから
# 実装後、仮想機械を使う
Machine.new(
  Assign.new(
    :x,
    Add.new(Variable.new(:x), Number.new(1))
  ),
  { x: Number.new(2) }
).run
```

## p.35 If/If(else節なし)のスニペット

```ruby
Machine.new(
  If.new(
    Variable.new(:x),
    Assign.new(:y, Number.new(1)),
    Assign.new(:y, Number.new(2))
  ),
  { x: Boolean.new(true) }
).run
```

```ruby
Machine.new(
  If.new(Variable.new(:x), Assign.new(:y, Number.new(1)), DoNothing.new),
  { x: Boolean.new(false) }
).run
```

