require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutArrays < Neo::Koan
  def test_creating_arrays
    empty_array = Array.new
    assert_equal Array, empty_array.class
    assert_equal 0, empty_array.size
  end

  # You can push onto the end of an array with <<
  def test_array_literals
    array = Array.new
    assert_equal [], array

    array[0] = 1
    assert_equal [1], array

    array[1] = 2
    assert_equal [1, 2], array

    array << 333
    assert_equal [1, 2, 333], array
  end

  def test_accessing_array_elements
    array = [:peanut, :butter, :and, :jelly]

    assert_equal :peanut, array[0]
    assert_equal :peanut, array.first
    assert_equal :jelly, array[3]
    assert_equal :jelly, array.last
    assert_equal :jelly, array[-1]
    assert_equal :butter, array[-3]
  end

  # Slicing arrays returns a subarray. The first argument is the position, the
  # second argument is the length.
  #
  # The position is slightly unusual in that it works differently than how you
  # index into the array when accessing its elements. The 0th position is 
  # before the 0th element, and the nth position is just after the N-1th
  # element. Therefore, a[0,1] returns the first element, and a[N,1] returns
  # an empty array. Specifying an invalid position (i.e. > a.length) will
  # return nil.
  #
  # Note that even if the length of the slice exceeds the total array length,
  # no elements are padded to the resulting subarray slice. 
  def test_slicing_arrays
    array = [:peanut, :butter, :and, :jelly]

    assert_equal [:peanut], array[0,1]
    assert_equal [:peanut, :butter], array[0,2]
    assert_equal [:and, :jelly], array[2,2]
    assert_equal [:and, :jelly], array[2,20]
    assert_equal [], array[4,0]
    assert_equal [], array[4,100]
    assert_equal nil, array[5,0]
  end

  # Ranges are an object of type Range
  # 
  # 1..5 is 1, 2, 3, 4, 5
  # whereas 1...5 is 1, 2, 3, 4
  # 
  # They respond to the to_a method, which returns an array of the 
  # sequence of numbers
  #
  # They also respond to each
  #
  def test_arrays_and_ranges
    assert_equal Range, (1..5).class
    assert_not_equal [1,2,3,4,5], (1..5)
    assert_equal [1,2,3,4,5], (1..5).to_a
    assert_equal [1,2,3,4], (1...5).to_a
  end

  # Arrays can be sliced by specifying a range of indexes to create a sliced
  # subarray.
  #
  # You can even specify -1 as the end of the range to slice until the end
  # of the array.
  #
  # Note that (1..-1).each { |n| puts n } actually puts nothing!
  #
  def test_slicing_with_ranges
    array = [:peanut, :butter, :and, :jelly]

    assert_equal [:peanut, :butter, :and], array[0..2]
    assert_equal [:peanut, :butter], array[0...2]
    assert_equal [:and, :jelly], array[2..-1]
  end

  # Pushing and popping is for the end of the array
  def test_pushing_and_popping_arrays
    array = [1,2]
    array.push(:last)

    assert_equal [1, 2, :last], array

    popped_value = array.pop
    assert_equal :last, popped_value
    assert_equal [1, 2], array
  end


  # Shifting and unshifting is for the front of the array. Unshifting with an
  # element allows you to add it to the front. Shifting the array permanently
  # alters it
  def test_shifting_arrays
    array = [1,2]
    array.unshift(:first)

    assert_equal [:first, 1, 2], array

    shifted_value = array.shift
    assert_equal :first, shifted_value
    assert_equal [1, 2], array
  end

end
