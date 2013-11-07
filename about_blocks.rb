require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutBlocks < Neo::Koan
  # result = yield will return result without requiring another explicit
  # reference to result. Is this done for clarity's sake?
  def method_with_block
    result = yield
    result
  end

  def test_methods_can_take_blocks
    yielded_result = method_with_block { 1 + 2 }
    assert_equal 3, yielded_result
  end

  def test_blocks_can_be_defined_with_do_end_too
    yielded_result = method_with_block do 1 + 2 end
    assert_equal 3, yielded_result
  end

  # ------------------------------------------------------------------

  def method_with_block_arguments
    yield("Jim")
  end

  # This makes sense intuitively -- when yield is invoked with arguments, they
  # are passed into the block.
  #
  # Question? What happens if there's a mismatch between the # of block
  # arguments vs. yield arguments?
  # 
  # Answer: any extra block arguments that don't have a corresponding yield
  # argument are nil. Any extra yield arguments are ignored by the block.
  def test_blocks_can_take_arguments
    method_with_block_arguments do |argument|
      assert_equal 'Jim', argument
    end
  end

  # ------------------------------------------------------------------

  def many_yields
    yield(:peanut)
    yield(:butter)
    yield(:and)
    yield(:jelly)
  end

  # You can't pass in multiple blocks to a method, but a method can invoke the
  # block multiple times.
  #
  # Question: is result "captured" by the block as a closure variable?
  #
  # Answer: I think so!
  #
  # Observation: result is a local variable scoped to this test method. It
  # can't be accessed within many_yields. However, in closure parlance, result
  # is an "open" or "free" variable" that's "enclosed" by the block. Therefore,
  # when many_yields invokes yield, it indirectly modifies result.
  #
  # If Ruby did not support closures, result would be some uninitialized value.
  def test_methods_can_call_yield_many_times
    result = []
    many_yields { |item| result << item }
    assert_equal [:peanut, :butter, :and, :jelly], result
  end

  # ------------------------------------------------------------------

  def yield_tester
    if block_given?
      yield
    else
      :no_block
    end
  end

  # Introduction to the block_given? method, which is defined in the Ruby
  # kernel
  def test_methods_can_see_if_they_have_been_called_with_a_block
    assert_equal :with_block, yield_tester { :with_block }
    assert_equal :no_block, yield_tester
  end

  # ------------------------------------------------------------------

  def test_block_can_affect_variables_in_the_code_where_they_are_created
    value = :initial_value
    method_with_block { value = :modified_in_a_block }
    assert_equal :modified_in_a_block, value
  end

  # Damnit, earlier I was trying to figure out how to define a block as a
  # variable! I kept doing x = {} which would bomb out with a syntax error, as
  # it expects it to be a hash. Precede it with the 'lambda' keyword!
  #
  # Note that call invokes the lambda function. You can use this if you have a
  # standalone lambda block as a variable. Otherwise, use yield.
  # 
  # Note the weird alternate syntax of using [] to invoke call.
  # 
  # Lambdas are instances of the Proc class. Careful passing the wrong number
  # of arguments to lambdas!
  # Straight from the Ruby docs: or procs created using lambda or ->() an error
  # is generated if the wrong number of parameters are passed to a Proc with
  # multiple parameters. For procs created using Proc.new or Kernel.proc, extra
  # parameters are silently discarded.
  def test_blocks_can_be_assigned_to_variables_and_called_explicitly
    add_one = lambda { |n| n + 1 }
    assert_equal 11, add_one.call(10)

    # Alternative calling syntax
    assert_equal 11, add_one[10]
  end

  # Note the & syntax to pass a lambda (standalone block) to a method that
  # takes a block.
  #
  # Poetry mode is legal:
  #
  # method_with_block_arguments &make_upper
  #
  # This is not legal (you get ArgumentError!):
  #
  # method_with_block_arguments make_upper
  # method_with_block_arguments(make_upper)
  def test_stand_alone_blocks_can_be_passed_to_methods_expecting_blocks
    make_upper = lambda { |n| n.upcase }
    result = method_with_block_arguments(&make_upper)
    assert_equal 'JIM', result
  end

  # ------------------------------------------------------------------

  # Here's a method where the block explicitly declares that it accepts a
  # block. Note the ampersand again.
  #
  # Side note: you can pass a block to *any* method, even one that never calls
  # yield. Methods can use block_given? to figure out how to behave.
  def method_with_explicit_block(&block)
    block.call(10)
  end

  # Note that when a method explicitly declares that it takes a block argument,
  # you can pass it either a normal block and a standalone lambda block.
  #
  # However, this is one case where you *cannot* pass a block to it implicitly
  # if you pass it explicitly, i.e. you can't hand it two blocks.
  #
  # def method_with_explicit_block(&block)
  #   block.call(10)
  #   yield(20)
  # end
  #
  # method_with_explicit_block(&block) { |n| n * 4 } # SyntaxError
  # method_with_explicit_block({ |n| n * 4 }) # SyntaxError
  # method_with_explicit_block { |n| n * 4 } # This is okay!
  def test_methods_can_take_an_explicit_block_argument
    assert_equal 20, method_with_explicit_block { |n| n * 2 }

    add_one = lambda { |n| n + 1 }
    assert_equal 11, method_with_explicit_block(&add_one)
  end

end
