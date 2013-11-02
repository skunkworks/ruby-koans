require File.expand_path(File.dirname(__FILE__) + '/neo')

def my_global_method(a,b)
  a + b
end

class AboutMethods < Neo::Koan

  def test_calling_global_methods
    assert_equal 5, my_global_method(2,3)
  end

  # It's okay to call global methods without parentheses as long as there's no
  # ambiguity about which arguments belong to which method invocation
  def test_calling_global_methods_without_parentheses
    result = my_global_method 2, 3
    assert_equal 5, result
  end

  # (NOTE: We are Using eval below because the example code is
  # considered to be syntactically invalid).
  def test_sometimes_missing_parentheses_are_ambiguous
    eval "assert_equal 5, my_global_method(2, 3)" # ENABLE CHECK
    #
    # Ruby doesn't know if you mean:
    #
    #   assert_equal(5, my_global_method(2), 3)
    # or
    #   assert_equal(5, my_global_method(2, 3))
    #
    # Rewrite the eval string to continue.
    #
  end

  # NOTE: wrong number of arguments is not a SYNTAX error, but a
  # runtime error.
  def test_calling_global_methods_with_wrong_number_of_arguments
    exception = assert_raise(ArgumentError) do
      my_global_method
    end
    assert_match(/wrong number of arguments/, exception.message)

    exception = assert_raise(ArgumentError) do
      my_global_method(1,2,3)
    end
    assert_match(/wrong number of arguments/, exception.message)
  end

  # ------------------------------------------------------------------

  def method_with_defaults(a, b=:default_value)
    [a, b]
  end

  def test_calling_with_default_values
    assert_equal [1, :default_value], method_with_defaults(1)
    assert_equal [1, 2], method_with_defaults(1, 2)
  end

  # ------------------------------------------------------------------

  def method_with_var_args(*args)
    args
  end

  # Splat operator! Variable arguments with splat operator get collected into
  # an array
  def test_calling_with_variable_arguments
    assert_equal Array, method_with_var_args.class
    assert_equal [], method_with_var_args
    assert_equal [:one], method_with_var_args(:one)
    assert_equal [:one, :two], method_with_var_args(:one, :two)
  end

  # ------------------------------------------------------------------

  def method_with_explicit_return
    :a_non_return_value
    return :return_value
    :another_non_return_value
  end

  def test_method_with_explicit_return
    assert_equal :return_value, method_with_explicit_return
  end

  # ------------------------------------------------------------------

  def method_without_explicit_return
    :a_non_return_value
    :return_value
  end

  def test_method_without_explicit_return
    assert_equal :return_value, method_without_explicit_return
  end

  # ------------------------------------------------------------------

  def my_method_in_the_same_class(a, b)
    a * b
  end

  def test_calling_methods_in_same_class
    assert_equal 12, my_method_in_the_same_class(3,4)
  end

  # Not 100% sure what the purpose of this is other than to demonstrate that
  # in this instance method, we can make an explicit call to the receiver of
  # the message (in this case, self)
  def test_calling_methods_in_same_class_with_explicit_receiver
    assert_equal 12, self.my_method_in_the_same_class(3,4)
  end

  # ------------------------------------------------------------------

  def my_private_method
    "a secret"
  end
  private :my_private_method

  # I knew from before that the private keyword will designate all methods
  # declared below it to be private, but I did not know that you can pass
  # it an explicit symbol as an argument to designate that method as a private
  # method.
  def test_calling_private_methods_without_receiver
    assert_equal 'a secret', my_private_method
  end

  # I didn't realize that it gives you an explicit error message that the
  # method is private. Also, that you can make an explicit call to a private
  # method inside an instance method, but that specifying yourself as the
  # receiver to that private method call effectively shuts you out.
  def test_calling_private_methods_with_an_explicit_receiver
    exception = assert_raise(NoMethodError) do
      self.my_private_method
    end
    assert_match /private method/, exception.message
  end

  # ------------------------------------------------------------------

  class Dog
    def name
      "Fido"
    end

    private

    def tail
      "tail"
    end
  end

  def test_calling_methods_in_other_objects_require_explicit_receiver
    rover = Dog.new
    assert_equal 'Fido', rover.name
  end

  def test_calling_private_methods_in_other_objects
    rover = Dog.new
    assert_raise(NoMethodError) do
      rover.tail
    end
  end
end
