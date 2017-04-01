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
