require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutObjects < Neo::Koan
  def test_everything_is_an_object
    assert_equal true, 1.is_a?(Object)
    assert_equal true, 1.5.is_a?(Object)
    assert_equal true, "string".is_a?(Object)
    assert_equal true, nil.is_a?(Object)
    assert_equal true, Object.is_a?(Object)
  end

  # to_s returns a string representation of an object
  def test_objects_can_be_converted_to_strings
    assert_equal "123", 123.to_s
    assert_equal '', nil.to_s
  end

  # inspect returns a string containing a human-readable representation
  # of an object that's more often used for debugging purposes
  def test_objects_can_be_inspected
    assert_equal "123", 123.inspect
    assert_equal 'nil', nil.inspect
  end

  def test_every_object_has_an_id
    obj = Object.new
    assert_equal Fixnum, obj.object_id.class
  end

  # Every object responds to an object_id method that returns a unique id for
  # each object. You can compare object ids to see whether two objects are
  # the same or different instances
  def test_every_object_has_different_id
    obj = Object.new
    another_obj = Object.new
    assert_equal true, obj.object_id != another_obj.object_id
  end

  # Yep, small integers have fixed object IDs.
  def test_small_integers_have_fixed_ids
    assert_equal 1, 0.object_id
    assert_equal 3, 1.object_id
    assert_equal 5, 2.object_id
    assert_equal 201, 100.object_id

    # THINK ABOUT IT:
    # What pattern do the object IDs for small integers follow?
    #
    # num.object_id = 2*num + 1
  end

  # Clone creates a new instance
  def test_clone_creates_a_different_object
    obj = Object.new
    copy = obj.clone

    assert_equal true, obj           != copy
    assert_equal true, obj.object_id != copy.object_id
  end
end
