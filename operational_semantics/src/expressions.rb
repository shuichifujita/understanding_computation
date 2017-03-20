module Inspectable
  def inspect
    "<<#{self}>>"
  end
end


class Number < Struct.new(:value)
  include Inspectable

  def to_s
    value.to_s
  end

  def reducible?
    false
  end
end


class Add < Struct.new(:left, :right)
  include Inspectable

  def to_s
    "#{left} + #{right}"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      Add.new(left.reduce(environment), right)
    elsif right.reducible?
      Add.new(left, right.reduce(environment))
    else
      Number.new(left.value + right.value)
    end
  end
end


class Multiply < Struct.new(:left, :right)
  include Inspectable

  def to_s
    "#{left} * #{right}"
  end

  def reducible?
    true
  end


  def reduce(environment)
    if left.reducible?
      Multiply.new(left.reduce(environment), right)
    elsif right.reducible?
      Multiply.new(left, right.reduce(environment))
    else
      Number.new(left.value * right.value)
    end
  end
end


class Boolean < Struct.new(:value)
  include Inspectable

  def to_s
    value.to_s
  end

  def reducible?
    false
  end
end


class LessThan < Struct.new(:left, :right)
  include Inspectable

  def to_s
    "#{left} < #{right}"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      LessThan.new(left.reduce(environment), right)
    elsif right.reducible?
      LessThan.new(left, right.reduce(environment))
    else
      Boolean.new(left.value < right.value)
    end
  end
end


class Variable < Struct.new(:name)
  include Inspectable

  def to_s
    name.to_s
  end

  def reducible?
    true
  end

  def reduce(environment)
    environment[name]
  end
end


class Machine < Struct.new(:expression, :environment)

  def step
    self.expression = expression.reduce(environment)
  end

  def run
    while expression.reducible?
      puts expression
      step
    end
    puts expression
  end
end


class DoNothing
  include Inspectable

  def to_s
    "do-nothing"
  end

  def ==(other_statement)
    other_statement.instance_of?(DoNothing)
  end

  def reducible?
    false
  end
end


class Assign < Struct.new(:name, :expression)
  include Inspectable

  def to_s
    "#{name} = #{expression}"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if expression.reducible?
      [Assign.new(name, expression.reduce(environment)), environment]
    else
      [DoNothing.new, environment.merge({name => expression})]
    end
  end
end

class If < Struct.new(:condition, :consequence, :alternative)
  include Inspectable

  def to_s
    "if (#{condition}) { #{consequence} } else { #{alternative} }"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if condition.reducible?
      [If.new(condition.reduce(environment), consequence, alternative), environment]
    else
      case condition
      when Boolean.new(true)
        [consequence, environment]
      when Boolean.new(false)
        [alternative, environment]
      end
    end
  end
end


# can use statement
class Machine < Struct.new(:statement, :environment)

  def step
    self.statement, self.environment = statement.reduce(environment)
  end

  def run
    while statement.reducible?
      puts "#{statement}, #{environment}"
      step
    end
    puts "#{statement}, #{environment}"
  end
end


class Sequence < Struct.new(:first, :second)
  include Inspectable

  def to_s
    "#{first}; #{second}"
  end

  def reducible?
    true
  end

  def reduce(environment)
    case first
    when DoNothing.new
      [second, environment]
    else
      reduced_first, reduced_environment = first.reduce(environment)
      [Sequence.new(reduced_first, second), reduced_environment]
    end
  end
end


class While < Struct.new(:condition, :body)
  include Inspectable

  def to_s
    "while (#{condition}) { #{body} }"
  end

  def reducible?
    true
  end

  def reducible(environment)
    [If.new(condition, Sequence.new(body, self), DoNothing.new), environment]
  end
end


# big step semantics
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


class Variable
  def evaluate(environment)
    environment[name]
  end
end


class Add
  def evaluate(environment)
    Number.new(left.evaluate(environment).value + right.evaluate(environment).value)
  end
end


class Multiply
  def evaluate(environment)
    Number.new(left.evaluate(environment).value * right.evaluate(environment).value)
  end
end


class LessThan
  def evaluate(environment)
    Boolean.new(left.evaluate(environment).value < right.evaluate(environment).value)
  end
end


class Assign
  def evaluate(environment)
    environment.merge({ name => expression.evaluate(environment) })
  end
end


class DoNothing
  def evaluate(environment)
    environment
  end
end


class If
  def evaluate(environment)
    case condition.evaluate(environment)
    when Boolean.new(true)
      consequence.evaluate(environment)
    when Boolean.new(false)
      alternative.evaluate(environment)
    end
  end
end


class Sequence
  def evaluate(environment)
    second.evaluate(first.evaluate(environment))
  end
end


class While
  def evaluate(environment)
    case condition.evaluate(environment)
    when Boolean.new(true)
      evaluate(body.evaluate(environment))
    when Boolean.new(false)
      environment
    end
  end
end

