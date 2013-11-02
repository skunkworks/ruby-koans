# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutRegularExpressions < Neo::Koan
  
  # Patterns are how we specify regular expressions
  def test_a_pattern_is_a_regular_expression
    assert_equal Regexp, /pattern/.class
  end

  # Can't believe I didn't know this, but the [] operator on a string can
  # take a pattern or Regexp. If the string matches, the part of the string
  # that matches will be returned. It will also return nil if it's not found.
  def test_a_regexp_can_search_a_string_for_matching_content
    assert_equal 'match', "some matching content"[/match/]
  end

  def test_a_failed_match_returns_nil
    assert_equal nil, "some matching content"[/missing/]
  end

  # ------------------------------------------------------------------

  def test_question_mark_means_optional
    assert_equal 'ab', "abbcccddddeeeee"[/ab?/]
    assert_equal 'a', "abbcccddddeeeee"[/az?/]
  end

  def test_plus_means_one_or_more
    assert_equal 'bccc', "abbcccddddeeeee"[/bc+/]
  end

  def test_asterisk_means_zero_or_more
    assert_equal 'abb', "abbcccddddeeeee"[/ab*/]
    assert_equal 'a', "abbcccddddeeeee"[/az*/]
    assert_equal '', "abbcccddddeeeee"[/z*/]

    # THINK ABOUT IT:
    #
    # When would * fail to match?
    #
    # Answer: Never. A pattern like /z*/ will match with anything. However, any
    # other parts of the pattern that don't use * may cause the match to fail,
    # but that doesn't seem to be in the spirit of the question being asked.
  end

  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why?
  #
  # Answer: the operators are greedy because they will "match up" the maximum 
  # amount of characters that they can without stepping on the rest of
  # the regex pattern. The splat (*) operator is very similar.

  # ------------------------------------------------------------------

  # Regular expressions match from left to right
  def test_the_left_most_match_wins
    assert_equal 'a', "abbccc az"[/az*/]
  end

  # ------------------------------------------------------------------

  # Brackets allow you to match one of a range of valid characters
  def test_character_classes_give_options_for_a_character
    animals = ["cat", "bat", "rat", "zat"]
    assert_equal ['cat', 'bat', 'rat'], animals.select { |a| a[/[cbr]at/] }
  end

  # There are obviously other shorthand ways to specify classes of characters
  def test_slash_d_is_a_shortcut_for_a_digit_character_class
    assert_equal '42', "the number is 42"[/[0123456789]+/]
    assert_equal '42', "the number is 42"[/\d+/]
  end

  def test_character_classes_can_include_ranges
    assert_equal '42', "the number is 42"[/[0-9]+/]
  end

  # Don't forget that tabs and newlines count as whitespace characters!
  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
    assert_equal " \t\n", "space: \t\n"[/\s+/]
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class
    # NOTE:  This is more like how a programmer might define a word.
    assert_equal 'variable_1', "variable_1 = 42"[/[a-zA-Z0-9_]+/]
    assert_equal 'variable_1', "variable_1 = 42"[/\w+/]
  end

  # Did not know this! Thought it was a wildcard for any character!
  def test_period_is_a_shortcut_for_any_non_newline_character
    assert_equal 'abc', "abc\n123"[/a.+/]
  end

  # A caret char (^) is like an anti-match
  def test_a_character_class_can_be_negated
    assert_equal 'the number is ', "the number is 42"[/[^0-9]+/]
  end

  # \D (non-digit) is the opposite of \d (digit)
  # \S (non-whitespace) is the opposite of \s (whitespace)
  # \W (any non-letter, non-digit, non-underscore char) is the opposite of \w
  def test_shortcut_character_classes_are_negated_with_capitals
    assert_equal 'the number is ', "the number is 42"[/\D+/]
    assert_equal 'space:', "space: \t\n"[/\S+/]
    # ... a programmer would most likely do
    assert_equal ' = ', "variable_1 = 42"[/[^a-zA-Z0-9_]+/]
    assert_equal ' = ', "variable_1 = 42"[/\W+/]
  end

  # ------------------------------------------------------------------

  # /\A...\z/ are anchors to the absolute start and end of the string
  # /^...$/ are anchors to the relative start and end of any line in the string
  # When would you use them?
  def test_slash_a_anchors_to_the_start_of_the_string
    assert_equal 'start', "start end"[/\Astart/]
    assert_equal nil, "start end"[/\Aend/]
  end

  def test_slash_z_anchors_to_the_end_of_the_string
    assert_equal 'end', "start end"[/end\z/]
    assert_equal nil, "start end"[/start\z/]
  end

  def test_caret_anchors_to_the_start_of_lines
    assert_equal '2', "num 42\n2 lines"[/^\d+/]
  end

  def test_dollar_sign_anchors_to_the_end_of_lines
    assert_equal '42', "2 lines\nnum 42"[/\d+$/]
  end

  # \b matches to the beginning or end of a word, where a word is defined as
  # a group of one or more consecutive alphanumeric + underscore characters.
  # It does not match with any whitespace characters that may exist before the
  # end of that word
  def test_slash_b_anchors_to_a_word_boundary
    assert_equal 'vines', "bovine vines"[/\bvine./]
  end

  # ------------------------------------------------------------------

  # You can specify regex match groups using parentheses. Doing so provides not
  # only the ability to specify precisely what group of characters to match
  # for, but also allows us to recall the group matches (as seen in the next
  # few examples)
  def test_parentheses_group_contents
    assert_equal 'hahaha', "ahahaha"[/(ha)+/]
  end

  # ------------------------------------------------------------------

  # A number can be supplied to act as a match capture group index to have it
  # return the specified match group.
  #
  # Note that this must be a *group*, i.e. a match within a set of parentheses.
  # For example, 'Richard'[/Richard/, 1] would return nil, since there is no
  # match group in the regex pattern /Richard/. On the other hand, something
  # like 'Richard'[/(Richard)/, 1] would return 'Richard'
  def test_parentheses_also_capture_matched_content_by_number
    assert_equal 'Gray', "Gray, James"[/(\w+), (\w+)/, 1]
    assert_equal 'James', "Gray, James"[/(\w+), (\w+)/, 2]
  end

  # I was vaguely familiar with the $1/$2/$N method of accessing matched groups
  # from a regex, but I didn't realize that they are automatically provided for
  # you after performing a match.
  def test_variables_can_also_be_used_to_access_captures
    assert_equal 'Gray, James', "Name:  Gray, James"[/(\w+), (\w+)/]
    assert_equal 'Gray', $1
    assert_equal 'James', $2
  end

  # ------------------------------------------------------------------

  # The first example is pretty straightforward to understand: our new regex
  # pattern matches either (James, Dana, or Summer) Gray.
  #
  # The second example does the same, but also asks for the matched content
  # group 1.
  #
  # The third example of course is a match miss, which would return nil, and
  # trying to get back match group 1 would still be nil.
  def test_a_vertical_pipe_means_or
    grays = /(James|Dana|Summer) Gray/
    assert_equal 'James Gray', "James Gray"[grays]
    assert_equal 'Summer', "Summer Gray"[grays, 1]
    assert_equal nil, "Jim Gray"[grays, 1]
  end

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).
  #
  # Answer: A character class specifies a range of valid matching characters
  # for a given match, whereas the alternation allows you to specify multiple
  # groups to match
  # ------------------------------------------------------------------

  # scan returns an array of *all* matches in a string for a given pattern.
  # Previous examples only returned the first match found in the string.
  #
  # With scan, if the pattern contains no groups as in the example below, the
  # resulting array will contain the matched strings. However, if the pattern
  # contains groups, each result in the array is itself an array containing
  # one entry per group in the pattern.
  def test_scan_is_like_find_all
    assert_equal ['one', 'two', 'three'], "one two-three".scan(/\w+/)
  end

  # Note that sub is only a one-time find-and-replace operation. gsub is a
  # find-and-replace-all operation!
  def test_sub_is_like_find_and_replace
    assert_equal 'one t-three', "one two-three".sub(/(t\w*)/) { $1[0, 1] }
  end

  def test_gsub_is_like_find_and_replace_all
    assert_equal 'one t-t', "one two-three".gsub(/(t\w*)/) { $1[0, 1] }
  end
end
