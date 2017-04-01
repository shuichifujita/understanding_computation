require '../../../base_definitions.rb'

## 各クラスはbaseのクラス定義にモンキーパッチしておる。

class Number
  def evaluate(environment)
    self
  end
end

class Boolean
  def evaluate(environment)
    self
  end
end

class Variable # args = {:name}
  def evaluate(environment)
    environment[name]
  end
end

class Add
  def evaluate(environment)
    ###########################################################################
    # Requiring recursive evaluation of their left and right subexpressions
    # before combining both values with the appropriate Ruby operator.
    # -->> Means, wait here until end of left expression's evaluation.
    ###########################################################################
    Number.new(left.evaluate(environment).value + right.evaluate(environment).value)
  end
end

class Multiply # args = {:left, :right}
  def evaluate(environment)
    Number.new(left.evaluate(environment).value * right.evaluate(environment).value)
  end
end

class LessThan
  def evaluate(environment)
    Boolean.new(left.evaluate(environment).value < right.evaluate(environment).value)
  end
end

# Statements

class Assign # args = {:name, :expression}
  def evaluate(environment)
    environment.merge({ name => expression.evaluate(environment) })
  end
end

class DoNothing
  def evaluate(environment)
    environment
  end
end

class If # args = {:condition, :consequence, :alternative}
  def evaluate(environment)
    case condition.evaluate(environment)
    when Boolean.new(true)
      consequence.evaluate(environment)
    when Boolean.new(false)
      alternative.evaluate(environment)
    end
  end
end

class Sequence # args = {:first, :second}
  def evaluate(environment)
    second.evaluate(first.evaluate(environment))
  end
end

