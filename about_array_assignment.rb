require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutArrayAssignment < Neo::Koan
  def test_non_parallel_assignment
    names = ["John", "Smith"]
    assert_equal ["John", "Smith"], names
  end

  # Array parallel assignments allow you to pluck values out of the array in
  # parallel
  def test_parallel_assignments
    first_name, last_name = ["John", "Smith"]
    assert_equal "John", first_name
    assert_equal "Smith", last_name
  end

  # During parallel assignment with arrays, extra values in the array are ignored
  def test_parallel_assignments_with_extra_values
    first_name, last_name = ["John", "Smith", "III"]
    assert_equal "John", first_name
    assert_equal 'Smith', last_name
  end

  # The splat operator will expand to capture as many items as it can. It wraps
  # those items into an array. It is often used in method definitions.
  def test_parallel_assignments_with_splat_operator
    first_name, *last_name = ["John", "Smith", "III"]
    assert_equal "John", first_name
    assert_equal ['Smith', 'III'], last_name
  end

  def test_parallel_assignments_with_too_few_variables
    first_name, last_name = ["Cher"]
    assert_equal "Cher", first_name
    assert_equal nil, last_name
  end

  def test_parallel_assignments_with_subarrays
    first_name, last_name = [["Willie", "Rae"], "Johnson"]
    assert_equal ['Willie', 'Rae'], first_name
    assert_equal 'Johnson', last_name
  end

  def test_parallel_assignment_with_one_variable
    first_name, = ["John", "Smith"]
    assert_equal 'John', first_name
  end

  # One very cool feature of parallel assignemnt is the ability to swap values
  # in two variables without needing a third temp item
  def test_swapping_with_parallel_assignment
    first_name = "Roy"
    last_name = "Rob"
    first_name, last_name = last_name, first_name
    assert_equal 'Rob', first_name
    assert_equal 'Roy', last_name
  end
end
