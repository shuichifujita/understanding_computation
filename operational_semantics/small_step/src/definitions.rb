require '../../../base_definitions.rb'

class Number

  def reducible?
    false
  end
end


class Add

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


class Multiply

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


class Boolean

  def reducible?
    false
  end
end


class LessThan

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

class And

  def reducible?
    true
  end

  #
  def reduce(environment)
    if left.reducible?
      And.new(left.reduce(environment), right)
    else
      if right.reducible?
        And.new(left, right.reduce(environment))
      else
        if ( left == Boolean.new(true) ) && ( right == Boolean.new(true) )
          Boolean.new(true)
        else
          Boolean.new(false)
        end
      end
    end
  end
end

class Or

  def reducible?
    true
  end

  #
  def reduce(environment)
    if left.reducible?
      Or.new(left.reduce(environment), right)
    else
      if right.reducible?
        Or.new(left, right.reduce(environment))
      else
        if ( left == Boolean.new(true) ) || ( right == Boolean.new(true) )
          Boolean.new(true)
        else
          Boolean.new(false)
        end
      end
    end
  end
end


class Variable

  def reducible?
    true
  end

  def reduce(environment)
    environment[name]
  end
end

class DoNothing
  # We want to be able to compare any two statements to see if
  # they're equal. the other syntax classes inherit
  # an implemantation of #== from Struct,
  # but DoNothing has not the method because of DoNothing does'nt
  # have any attributes.
  def==(other_statement)
    other_statement.instance_of? DoNothing
  end

  def reducible?
    false
  end
end

class Assign

  def reducible?
    true
  end

  ### [ ASSIGN ] statement the reduction rule ##################################
  # * If the assignment’s expression can be reduced,
  #   then reduce it, resulting in a reduced assignment statement
  #   and an unchanged environment.
  #
  # * If the assignment’s expression can’t be reduced,
  #   then update the environment to associate that
  #   expression with the assignment’s variable,
  #   resulting in a «do-nothing» statement and a new environment.
  ##############################################################################
  def reduce(environment)
    if expression.reducible?
      [Assign.new(name, expression.reduce(environment)), environment]
    else
      [DoNothing.new, environment.merge({ name => expression })]
    end
  end
end

class If

  def reducible?
    true
  end

  ### [ IF ] statement the reduction rule ######################################
  # * If the condition can be reduced, then reduce it,
  #   resulting in a reduced conditional statement and an unchanged environment.
  #
  # * If the condition is the expression «true»,
  #   reduce to the consequence statement and an unchanged environment.
  #
  # * If the condition is the expression «false»,
  #   reduce to the alternative statement and an unchanged environment.
  ##############################################################################
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

class Sequence

  def reducible?
    true
  end

  ### [ Sequence ] statement the reduction rule ################################
  ### * If the first statement is a <<do-nothing>> statement,
  ###   reduce to the second statement ant the original environment.
  ###
  ### * If the first statement is not <<do-nothing>>, then reduce it,
  ###   resulting in a new sequence
  ###   (the reduced first statement followed by the scond statement)
  ###   and a reduced environment.
  ##############################################################################
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

class While

  def reducible?
    true
  end

  ### [ While ] statement the reduction rule ###################################
  ### * Reduce
  ###     «while (condition) { body }»
  ###   to
  ###     «if (condition) { body; while (condition) { body } } else { do-nothing }»
  ###   and an unchanged environment.
  ##############################################################################

  def reduce(environment)
    [
      If.new(condition,
        Sequence.new(body, self),
        DoNothing.new
      ),
      environment
    ]
  end
end

class Machine
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
