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
end

class Add < Struct.new(:left, :right)
  include Inspectable

  def to_s
    "#{left} + #{right}"
  end
end

class Multiply < Struct.new(:left, :right)
  include Inspectable

  def to_s
    "#{left} * #{right}"
  end
end
