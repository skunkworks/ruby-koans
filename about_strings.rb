require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutStrings < Neo::Koan
  def test_double_quoted_strings_are_strings
    string = "Hello, World"
    assert_equal true, string.is_a?(String)
  end

  def test_single_quoted_strings_are_also_strings
    string = 'Goodbye, World'
    assert_equal true, string.is_a?(String)
  end

  def test_use_single_quotes_to_create_string_with_double_quotes
    string = 'He said, "Go Away."'
    assert_equal 'He said, "Go Away."', string
  end

  def test_use_double_quotes_to_create_strings_with_single_quotes
    string = "Don't"
    assert_equal "Don't", string
  end

  # Double-quote strings require escaping double-quote chars.
  # Single-quote strings require escaping single-quote chars.
  def test_use_backslash_for_those_hard_cases
    a = "He said, \"Don't\""
    b = 'He said, "Don\'t"'
    assert_equal true, a == b
  end

  # You can use any non-numeric, non-alphabetical character for flexible
  # quote strings, which handle single- and double-quote chars with ease
  def test_use_flexible_quoting_to_handle_really_hard_cases
    a = %(flexible quotes can handle both ' and " characters)
    b = %!flexible quotes can handle both ' and " characters!
    c = %{flexible quotes can handle both ' and " characters}
    assert_equal true, a == b
    assert_equal true, a == c
  end

  # Flexible quotes handle multiple lines, but be careful of indentation! It
  # will capture all spaces/tabs.
  def test_flexible_quotes_can_handle_multiple_lines
    long_string = %{
It was the best of times,
It was the worst of times.
}
    assert_equal 54, long_string.length
    assert_equal 3, long_string.lines.count
    assert_equal "\n", long_string[0,1]
  end

  # This is called a heredoc, and you can use any string as a delimiter, e.g.
  # <<ASDF
  # this is totally ok
  # ASDF
  #
  # The only rule is that the delimiters belong on their own lines
  def test_here_documents_can_also_handle_multiple_lines
    long_string = <<EOS
It was the best of times,
It was the worst of times.
EOS
    assert_equal 53, long_string.length
    assert_equal 2, long_string.lines.count
    assert_equal "I", long_string[0,1]
  end

  def test_plus_will_concatenate_two_strings
    string = "Hello, " + "World"
    assert_equal "Hello, World", string
  end

  # The concat operator creates and returns a new string instance, which leaves
  # the source strings unmolested.
  def test_plus_concatenation_will_leave_the_original_strings_unmodified
    hi = "Hello, "
    there = "World"
    string = hi + there
    assert_equal "Hello, ", hi
    assert_equal "World", there
  end

  # The += operator will concat to the end of a string.
  #
  # In this case, the hi variable is altered to be "Hello, World", but...
  def test_plus_equals_will_concatenate_to_the_end_of_a_string
    hi = "Hello, "
    there = "World"
    hi += there
    assert_equal "Hello, World", hi
  end

  # ...if there are any other variables that are pointing at the original
  # string, you can see that the += operator does not alter the original
  # string itself.
  #
  # This means that += is like a concat and assignment in one LoC, since
  # like the + concat operator, it does not alter the existing strings
  def test_plus_equals_also_will_leave_the_original_string_unmodified
    original_string = "Hello, "
    hi = original_string
    there = "World"
    hi += there
    assert_equal "Hello, ", original_string
  end

  # The shovel operator appends to the end of a string, but unlike concat, it
  # *does* alter the original string
  def test_the_shovel_operator_will_also_append_content_to_a_string
    hi = "Hello, "
    there = "World"
    hi << there
    assert_equal "Hello, World", hi
    assert_equal "World", there
  end

  def test_the_shovel_operator_modifies_the_original_string
    original_string = "Hello, "
    hi = original_string
    there = "World"
    hi << there
    assert_equal "Hello, World", original_string

    # THINK ABOUT IT:
    #
    # Ruby programmers tend to favor the shovel operator (<<) over the
    # plus equals operator (+=) when building up strings.  Why?
    #
    # Answer: because the += operator requires allocating a brand-new
    # string rather than modifying the original string, which requires
    # more memory.
  end

  def test_double_quoted_string_interpret_escape_characters
    string = "\n"
    assert_equal 1, string.size
  end

  def test_single_quoted_string_do_not_interpret_escape_characters
    string = '\n'
    assert_equal 2, string.size
  end

  # Single-quoted strings only escape the backslash and single-quote chars.
  # Double-quoted strings support the full range of escape chars.
  def test_single_quotes_sometimes_interpret_escape_characters
    string = '\\\''
    assert_equal 2, string.size
    assert_equal "\\'", string
  end

  def test_double_quoted_strings_interpolate_variables
    value = 123
    string = "The value is #{value}"
    assert_equal "The value is 123", string
  end

  def test_single_quoted_strings_do_not_interpolate
    value = 123
    string = 'The value is #{value}'
    assert_equal "The value is #\{value\}", string
  end

  def test_any_ruby_expression_may_be_interpolated
    string = "The square root of 5 is #{Math.sqrt(5)}"
    assert_equal 'The square root of 5 is 2.23606797749979', string
  end

  # Like an array, you can slice a string to get a substring
  def test_you_can_get_a_substring_from_a_string
    string = "Bacon, lettuce and tomato"
    assert_equal 'let', string[7,3]
    assert_equal 'let', string[7..9]
  end

  # You can directly index into a string to get its chars. Note that if you
  # want all chars of a string, you can use the chars method.
  #
  # "abcd".chars.each { |c| puts c }
  #
  # or use the each_char method to have it directly return an Enumerable object
  #
  # "abcd".each_char { |c| puts c }
  def test_you_can_get_a_single_character_from_a_string
    string = "Bacon, lettuce and tomato"
    assert_equal 'a', string[1]

    # Surprised?
  end

  # It's slightly weird, but char literals in Ruby are ?x, where x is the char.
  # In 1.8 and below, chars were represented by integers, but now they are
  # represented by strings.
  in_ruby_version("1.8") do
    def test_in_older_ruby_single_characters_are_represented_by_integers
      assert_equal 97, ?a
      assert_equal true, ?a == 97

      assert_equal true, ?b == (?a + 1)
    end
  end

  in_ruby_version("1.9", "2") do
    def test_in_modern_ruby_single_characters_are_represented_by_strings
      assert_equal 'a', ?a
      assert_equal false, ?a == 97
    end
  end

  # Splitting will tokenize a string into an array
  def test_strings_can_be_split
    string = "Sausage Egg Cheese"
    words = string.split
    assert_equal ['Sausage', 'Egg', 'Cheese'], words
  end

  # You can specify the delimiter as an argument to split
  def test_strings_can_be_split_with_different_patterns
    string = "the:rain:in:spain"
    words = string.split(/:/)
    assert_equal ['the', 'rain', 'in', 'spain'], words

    # NOTE: Patterns are formed from Regular Expressions.  Ruby has a
    # very powerful Regular Expression library.  We will become
    # enlightened about them soon.
  end

  # Join strings together
  def test_strings_can_be_joined
    words = ["Now", "is", "the", "time"]
    assert_equal 'Now is the time', words.join(" ")
  end

  # Unlike symbols, strings are unique objects
  def test_strings_are_unique_objects
    a = "a string"
    b = "a string"

    assert_equal true, a           == b
    assert_equal false, a.object_id == b.object_id
  end
end
