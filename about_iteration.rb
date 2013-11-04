require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutIteration < Neo::Koan

  # -- An Aside ------------------------------------------------------
  # Ruby 1.8 stores names as strings. Ruby 1.9 stores names as
  # symbols. So we use a version dependent method "as_name" to convert
  # to the right format in the koans.  We will use "as_name" whenever
  # comparing to lists of methods.

  in_ruby_version("1.8") do
    def as_name(name)
      name.to_s
    end
  end

  in_ruby_version("1.9", "2.0") do
    def as_name(name)
      name.to_sym
    end
  end

  # Ok, now back to the Koans.
  # -------------------------------------------------------------------

  def test_each_is_a_method_on_arrays
    assert_equal true, [].methods.include?(as_name(:each))
  end

  def test_iterating_with_each
    array = [1, 2, 3]
    sum = 0
    array.each do |item|
      sum += item
    end
    assert_equal 6, sum
  end

  def test_each_can_use_curly_brace_blocks_too
    array = [1, 2, 3]
    sum = 0
    array.each { |item| sum += item }
    assert_equal 6, sum
  end

  # Breaking out of each-style iterations is new to me
  def test_break_works_with_each_style_iterations
    array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    sum = 0
    array.each do |item|
      break if item > 3
      sum += item
    end
    assert_equal 6, sum
  end

  # First time using the collect method.
  # First impression, it seems to be similar to the map method?
  #
  # Formal definition: Invokes the given block once for each element of self.
  # Creates a new array containing the values returned by the block.
  #
  # Turns out that collect and map are identical!
  #
  # Does not alter original array. Bang version of method does, however.
  def test_collect_transforms_elements_of_an_array
    array = [1, 2, 3]
    new_array = array.collect { |item| item + 10 }
    assert_equal [11, 12, 13], new_array

    another_array = array.map { |item| item + 10 }
    assert_equal [11, 12, 13], another_array
  end

  # select invokes the given block once for each element of an array and
  # creates a new array containing the values for which the block returned a
  # true value. (Synonym: find_all)
  def test_select_selects_certain_items_from_an_array
    array = [1, 2, 3, 4, 5, 6]

    even_numbers = array.select { |item| (item % 2) == 0 }
    assert_equal (2..6).step(2).to_a, even_numbers

    # NOTE: 'find_all' is another name for the 'select' operation
    more_even_numbers = array.find_all { |item| (item % 2) == 0 }
    assert_equal [2, 4, 6], more_even_numbers
  end

  # find method runs the given block and returns the first element for which
  # the block returns a true value
  def test_find_locates_the_first_element_matching_a_criteria
    array = ["Jim", "Bill", "Clarence", "Doug", "Eli"]

    assert_equal 'Clarence', array.find { |item| item.size > 4 }
  end

  # inject method and reduce method are synonyms!
  # map/reduce == collect/inject
  #
  # Formal definition: combines elements of an enumerable by applying an
  # operation.
  #
  # If you send it a block, the first arg is the "accumulator" and the second
  # arg is the current iterated item.
  #
  # The argument to inject is the initial value of the accumulator. If you
  # don't provide one, the first item serves as the initial value.
  def test_inject_will_blow_your_mind
    result = [2, 3, 4].inject(0) { |sum, item| sum + item }
    assert_equal 9, result

    result2 = [2, 3, 4].inject(1) { |product, item| product * item }
    assert_equal 24, result2

    # Extra Credit:
    # Describe in your own words what inject does.
  end

  # This makes sense. Arrays, ranges, hashes respond to these methods. Files
  # on the other hand...
  def test_all_iteration_methods_work_on_any_collection_not_just_arrays
    # Ranges act like a collection
    result = (1..3).map { |item| item + 10 }
    assert_equal [11, 12, 13], result

    # Files act like a collection of lines. Mix-ins? Or does it just quack like
    # a collection-duck?
    File.open("example_file.txt") do |file|
      upcase_lines = file.map { |line| line.strip.upcase }
      assert_equal ['THIS', 'IS', 'A', 'TEST'], upcase_lines
    end

    # NOTE: You can create your own collections that work with each,
    # map, select, etc.
  end

  # Bonus Question:  In the previous koan, we saw the construct:
  #
  #   File.open(filename) do |file|
  #     # code to read 'file'
  #   end
  #
  # Why did we do it that way instead of the following?
  #
  #   file = File.open(filename)
  #   # code to read 'file'
  #
  # When you get to the "AboutSandwichCode" koan, recheck your answer.
  #
  # Answer: Passing a block to File.open will automatically handle closing the
  # file handle once the block is finished. Since the koan performs an
  # assertion while the file is open, it would throw an exception without
  # closing the file first.

end
