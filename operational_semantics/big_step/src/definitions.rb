require '../../../base_definitions.rb'

## 各クラスはbaseのクラス定義にモンキーパッチしておる。

class Logger
  @stack = []

  def self.log(me, env)
    puts "#evaluate at: #{me.class}, env: #{env}"
    @stack.push(me.class.name)
    puts @stack.join(':')
  end

  def self.clear
    @stack = []
  end
end

class Number
  def evaluate(environment)
    Logger.log(self, environment)
    self
  end
end

class Boolean
  def evaluate(environment)
    Logger.log(self, environment)
    self
  end
end

class Variable # args = {:name}
  def evaluate(environment)
    Logger.log(self, environment)
    environment[name]
  end
end

class Add
  def evaluate(environment)
    Logger.log(self, environment)
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
    Logger.log(self, environment)
    Number.new(left.evaluate(environment).value * right.evaluate(environment).value)
  end
end

class LessThan
  def evaluate(environment)
    Logger.log(self, environment)
    Boolean.new(left.evaluate(environment).value < right.evaluate(environment).value)
  end
end

# Statements

class Assign # args = {:name, :expression}
  def evaluate(environment)
    Logger.log(self, environment)
    environment.merge({ name => expression.evaluate(environment) })
  end
end

class DoNothing
  def evaluate(environment)
    Logger.log(self, environment)
    environment
  end
end

class If # args = {:condition, :consequence, :alternative}
  def evaluate(environment)
    Logger.log(self, environment)
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
    Logger.log(self, environment)
    second.evaluate(first.evaluate(environment))
  end
end

class While # args = {:condition, :body}

  ### While Behavior ###########################################################
  # * Evaluate the condition to get either «true» or «false».
  #
  # * If the condition evaluates to «true»,
  #   evaluate the body to get a new environment,
  #   then repeat the loop within that new environment
  #   (i.e., evaluate the whole «while» statement again)
  #   and return the resulting environment.
  #
  # * If the condition evaluates to «false», return the environment unchanged.
  #
  ##############################################################################

  def evaluate(environment)
    Logger.log(self, environment)
    case condition.evaluate(environment) # <- WATCH ENVRIONMENT AGAIN AND AGAIN, IN ANY LOOP TIME.
    when Boolean.new(true)
      evaluate(body.evaluate(environment))
      #              ☝️ get the new envrionment
      # ☝️ call self.evaluate (evaluate the whole «while» statement again)
    when Boolean.new(false)
      environment
    end
  end
end
