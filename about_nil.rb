require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutNil < Neo::Koan
  def test_nil_is_an_object
    assert_equal true, nil.is_a?(Object), "Unlike NULL in other languages"
  end

  # Calling a method on nil doesn't give you a null pointer reference error.
  # Instead, it tells you that the Nil class doesn't have that method, since
  # nil is an object
  def test_you_dont_get_null_pointer_errors_when_calling_methods_on_nil
    # What happens when you call a method that doesn't exist.  The
    # following begin/rescue/end code block captures the exception and
    # makes some assertions about it.
    begin
      nil.some_method_nil_doesnt_know_about
    rescue Exception => ex
      # What exception has been caught?
      assert_equal NoMethodError, ex.class

      # What message was attached to the exception?
      # (HINT: replace __ with part of the error message.)
      assert_match(/undefined method/, ex.message)
    end
  end

  # Nil does have a few methods defined.
  #
  # Note that to_s and to_str are slightly different. to_s is implemented by
  # all classes to return a string representation of itself, whereas to_str
  # should only be used by String-like classes that expect to be implicitly
  # coerced/cast to a string
  def test_nil_has_a_few_methods_defined_on_it
    assert_equal true, nil.nil?
    assert_equal "", nil.to_s
    assert_equal "nil", nil.inspect

    # THINK ABOUT IT:
    #
    # Is it better to use
    #    obj.nil?
    # or
    #    obj == nil
    # Why?
    #
    # Answer: better to use obj.nil? because it's shorter and more idiomatic
    # Ruby. obj == nil makes more sense in languages where nil is not an
    # object and calling a method on nil can throw an exception
  end

end
