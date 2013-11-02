require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutControlStatements < Neo::Koan

  def test_if_then_else_statements
    if true
      result = :true_value
    else
      result = :false_value
    end
    assert_equal :true_value, result
  end

  def test_if_then_statements
    result = :default_value
    if true
      result = :true_value
    end
    assert_equal :true_value, result
  end

  # Didn't know you don't need to use the ternary operator (?) and that you can
  # straight-up embed an if-else conditional to set values.
  def test_if_statements_return_values
    value = if true
              :true_value
            else
              :false_value
            end
    assert_equal :true_value, value

    value = if false
              :true_value
            else
              :false_value
            end
    assert_equal :false_value, value

    # NOTE: Actually, EVERY statement in Ruby will return a value, not
    # just if statements.
    #
    # Another note: you see this in action when messing around in the command
    # line interpreter. Calls to everything return some value.
  end

  def test_if_statements_with_no_else_with_false_condition_return_value
    value = if false
              :true_value
            end
    assert_equal nil, value
  end

  def test_condition_operators
    assert_equal :true_value, (true ? :true_value : :false_value)
    assert_equal :false_value, (false ? :true_value : :false_value)
  end

  # Another novel use of inline-ing an if conditional to set a value
  def test_if_statement_modifiers
    result = :default_value
    result = :true_value if true

    assert_equal :true_value, result
  end

  # The 'unless' conditional statement is still a bit unintuitive to me.
  # I have to think about it in my head like this: "I will execute this
  # statement UNLESS this condition proves true."
  def test_unless_statement
    result = :default_value
    unless false    # same as saying 'if !false', which evaluates as 'if true'
      result = :false_value
    end
    assert_equal :false_value, result
  end

  def test_unless_statement_evaluate_true
    result = :default_value
    unless true    # same as saying 'if !true', which evaluates as 'if false'
      result = :true_value
    end
    assert_equal :default_value, result
  end

  # Works just like inline-if statement from before.
  def test_unless_statement_modifier
    result = :default_value
    result = :false_value unless false

    assert_equal :false_value, result
  end

  def test_while_statement
    i = 1
    result = 1
    while i <= 10
      result = result * i
      i += 1
    end
    assert_equal 3628800, result
  end

  def test_break_statement
    i = 1
    result = 1
    while true
      break unless i <= 10
      result = result * i
      i += 1
    end
    assert_equal 3628800, result
  end

  # Much like inline-ing the if and unless statements, you can do the same with
  # while loops. It isn't very readable, however.
  #
  # The point of this koan is to demonstrate that the break statement behaves
  # like a return statement in a while loop.
  def test_break_statement_returns_values
    i = 1
    result = while i <= 10
      break i if i % 2 == 0
      i += 1
    end

    assert_equal 2, result
  end

  # Note the very cool step method (Range#step), which returns an iterator that
  # steps through a range of values with step size N. To create an array of
  # values, you can call to_a on a Range or an Enumerator to get back an array
  # of the values. Chaining this with a call to step(2) allows us to get back
  # the odd numbers from 1 to 10.
  def test_next_statement
    i = 0
    result = []
    while i < 10
      i += 1
      next if (i % 2) == 0
      result << i
    end
    assert_equal (1..10).step(2).to_a, result
  end

  def test_for_statement
    array = ["fish", "and", "chips"]
    result = []
    for item in array
      result << item.upcase
    end
    assert_equal ['FISH', 'AND', 'CHIPS'], result
  end

  # Note that the times method on a number returns an Enumerator. You can pass
  # a block directly to an enumerator to have it perform an operation on each
  # element it contains.
  def test_times_statement
    sum = 0
    10.times do
      sum += 1
    end
    assert_equal 10, sum
  end

end
