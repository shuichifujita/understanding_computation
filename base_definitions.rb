class Struct
  def inspect
    "<<#{self}>>"
  end
end

class Number < Struct.new(:value)
  def to_s
    value.to_s
  end
end

class Boolean < Struct.new(:value)
  def to_s
    value.to_s
  end
end

class Add < Struct.new(:left, :right)
  def to_s
    "#{left} + #{right}"
  end
end


class Multiply < Struct.new(:left, :right)
  def to_s
    "#{left} * #{right}"
  end
end

class LessThan < Struct.new(:left, :right)
  def to_s
    "#{left} < #{right}"
  end
end

class And < Struct.new(:left, :right)
  def to_s
    "#{left} and #{right}"
  end
end

class Or < Struct.new(:left, :right)
  def to_s
    "#{left} or #{right}"
  end
end

class Variable < Struct.new(:name)
  def to_s
    name.to_s
  end
end

class DoNothing

  def inspect
    "<<#{self}>>"
  end

  def to_s
    'do-nothing'
  end

  def==(other_statement)
    other_statement.instance_of? DoNothing
  end
end

class Assign < Struct.new(:name, :expression)
  def to_s
    "#{name} = #{expression}"
  end
end

class If < Struct.new(:condition, :consequence, :alternative)
  def to_s
    "if (#{condition}) { #{consequence} } else { #{alternative} }"
  end
end

class Sequence < Struct.new(:first, :second)
  def to_s
    "#{first}; #{second}"
  end
end

class While < Struct.new(:condition, :body)
  def to_s
    "while (#{condition}) { #{body} }"
  end
end

class Machine < Struct.new(:statement, :environment)
  def to_s
    "Machine has: #{statement}, #{environment}"
  end
end
