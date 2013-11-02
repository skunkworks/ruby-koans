require File.expand_path(File.dirname(__FILE__) + '/neo')

C = "top level"

class AboutConstants < Neo::Koan

  # Don't forget that any capitalized variable is a constant!
  C = "nested"

  def test_nested_constants_may_also_be_referenced_with_relative_paths
    assert_equal 'nested', C
  end

  # I've wondered what the double-colon notation meant. I've seen it when
  # referencing other modules, e.g. Nokogiri::XML, or Neo::Koan. The formal
  # definition is:
  #
  # The :: is a unary operator that allows: constants, instance methods and
  # class methods defined within a class or module, to be accessed from
  # anywhere outside the class or module.
  #
  # In plain English, this means that it's a namespace operator that allows you
  # to specify exactly which constant or method in which class/module you're
  # trying to access. In C#, you can accomplish this with namespace dot
  # notation.
  #
  # Note that a naked :: without anything preceding it is the global scope.
  def test_top_level_constants_are_referenced_by_double_colons
    assert_equal 'top level', ::C
  end

  def test_nested_constants_are_referenced_by_their_complete_path
    assert_equal 'nested', AboutConstants::C
    assert_equal 'nested', ::AboutConstants::C
  end

  # ------------------------------------------------------------------

  class Animal
    LEGS = 4
    def legs_in_animal
      LEGS
    end

    class NestedAnimal
      def legs_in_nested_animal
        LEGS
      end
    end
  end

  # Constants are inherited by nested classes
  def test_nested_classes_inherit_constants_from_enclosing_classes
    assert_equal 4, Animal::NestedAnimal.new.legs_in_nested_animal
  end

  # ------------------------------------------------------------------

  class Reptile < Animal
    def legs_in_reptile
      LEGS
    end
  end

  # Similarly, subclasses will inherit constants from parent classes
  def test_subclasses_inherit_constants_from_parent_classes
    assert_equal 4, Reptile.new.legs_in_reptile
  end

  # ------------------------------------------------------------------

  class MyAnimals
    LEGS = 2

    class Bird < Animal
      def legs_in_bird
        LEGS
      end
    end
  end

  def test_who_wins_with_both_nested_and_inherited_constants
    assert_equal 2, MyAnimals::Bird.new.legs_in_bird
  end

  # QUESTION: Which has precedence: The constant in the lexical scope,
  # or the constant from the inheritance hierarchy?
  #
  # Answer: the constant in the lexical scope holds precedence over any
  # inherited constants.
  # ------------------------------------------------------------------

  class MyAnimals::Oyster < Animal
    def legs_in_oyster
      LEGS
    end
  end

  def test_who_wins_with_explicit_scoping_on_class_definition
    assert_equal 4, MyAnimals::Oyster.new.legs_in_oyster
  end

  # QUESTION: Now which has precedence: The constant in the lexical
  # scope, or the constant from the inheritance hierarchy?  Why is it
  # different than the previous answer?
  #
  # Answer: The constant from the inheritance hierarchy now has precedence.
  # This is because the class definition of the Oyster class is not technically
  # in the lexical scope of MyAnimals, it's only in the same namespace based
  # on its class definition.
  # 
  # If you print out the nesting by doing p Module.nesting in each class, you'd
  # see that although Oyster is in the MyAnimals namespace, it doesn't inherit
  # anything defined in MyAnimals.
end
