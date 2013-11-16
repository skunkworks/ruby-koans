require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutClassMethods < Neo::Koan
  class Dog
  end

  def test_objects_are_objects
    fido = Dog.new
    assert_equal true, fido.is_a?(Object)
  end

  def test_classes_are_classes
    assert_equal true, Dog.is_a?(Class)
  end

  def test_classes_are_objects_too
    assert_equal true, Dog.is_a?(Object)
  end

  def test_objects_have_methods
    fido = Dog.new
    assert fido.methods.size > 0
  end

  # The pedagogical point is that instances and classes have different sets of
  # methods, and you can see what instance methods and class methods are by
  # calling methods. We already know that classes themselves are just
  # Class instances.
  def test_classes_have_methods
    assert Dog.methods.size > 0
  end

  # Learned something new! You can add a method onto just one particular
  # instance of a class. These are known as singleton methods. It seems to
  # have limited utility at first glance.
  def test_you_can_define_methods_on_individual_objects
    fido = Dog.new
    def fido.wag
      :fidos_wag
    end
    assert_equal :fidos_wag, fido.wag
  end

  def test_other_objects_are_not_affected_by_these_singleton_methods
    fido = Dog.new
    rover = Dog.new
    def fido.wag
      :fidos_wag
    end

    assert_raise(NoMethodError) do
      rover.wag
    end
  end

  # ------------------------------------------------------------------

  class Dog2
    def wag
      :instance_level_wag
    end
  end

  def Dog2.wag
    :class_level_wag
  end

  def test_since_classes_are_objects_you_can_define_singleton_methods_on_them_too
    assert_equal :class_level_wag, Dog2.wag
  end

  def test_class_methods_are_independent_of_instance_methods
    fido = Dog2.new
    assert_equal :instance_level_wag, fido.wag
    assert_equal :class_level_wag, Dog2.wag
  end

  # ------------------------------------------------------------------

  class Dog
    attr_accessor :name
  end

  def Dog.name
    @name
  end

  # Somewhat counterintuitively, you can create instance variables inside a
  # class object. Having Dog.name return @name has it return the instance
  # variable defined in the class object itself
  def test_classes_and_instances_do_not_share_instance_variables
    fido = Dog.new
    fido.name = "Fido"
    assert_equal 'Fido', fido.name
    assert_equal nil, Dog.name
  end

  # ------------------------------------------------------------------

  class Dog
    def Dog.a_class_method
      :dogs_class_method
    end
  end

  # Can define it as either Dog.a_class_method or self.a_class_method
  def test_you_can_define_class_methods_inside_the_class
    assert_equal :dogs_class_method, Dog.a_class_method
  end

  # ------------------------------------------------------------------

  # I'm uncertain what the deeper meaning of this koan is...
  LastExpressionInClassStatement = class Dog
                                     21
                                   end

  def test_class_statements_return_the_value_of_their_last_expression
    assert_equal 21, LastExpressionInClassStatement
  end

  # ------------------------------------------------------------------

  SelfInsideOfClassStatement = class Dog
                                 self
                               end

  def test_self_while_inside_class_is_class_object_not_instance
    assert_equal true, Dog == SelfInsideOfClassStatement
  end

  # ------------------------------------------------------------------

  class Dog
    def self.class_method2
      :another_way_to_write_class_methods
    end
  end

  def test_you_can_use_self_instead_of_an_explicit_reference_to_dog
    assert_equal :another_way_to_write_class_methods, Dog.class_method2
  end

  # ------------------------------------------------------------------

  # Boggling my mind a little bit here. First time running into this way of
  # defining a class method. Did some research, came up with this:
  #
  # http://yehudakatz.com/2009/11/15/metaprogramming-in-ruby-its-all-about-the-self
  #
  # In a nutshell:
  #
  # Every object belongs to its own invisible metaclass. This is what allows
  # us to define methods directly on instances of an object that are not
  # available to instances of the same class: the methods are defined on the
  # metaclass of the instance.
  #
  # When we open up a class, self is defined as the instance of the class
  # itself. Thus, doing "def some_method" will add some_method to instances
  # of that class, but doing "def self.some_method" will add some_method to
  # the class instance itself.
  #
  # class_eval allows you to pass in a string or block and defines self as the
  # class instance. Thus, passing in "def some_method" to class_eval would
  # define it for instances of that class. (Note: class_eval is an alias for
  # module_eval, and it's only available in Modules and in the Class class
  # instance).
  #
  # We don't even need to open the class to define a class method on it. We can
  # add a method to the class by adding it to its metaclass:
  # def Person.some_method ; 'blahblah'; end;
  #
  # class << Person is Ruby shorthand syntax for accessing an object's
  # metaclass directly. That means we can do this:
  # class << Person
  #   def some_method...
  # 
  # and now Person will respond to some_method, but semantically, that method
  # is actually defined in the class object's metaclass and not the class
  # object itself.
  #
  # Finally, instance_eval splits self into two selves:
  #   1. When defining a method, self is the metaclass. Therefore, methods
  #      are defined as "class methods"
  #   2. Otherwise, self refers to the class instance itself.
  class Dog
    class << self
      def another_class_method
        :still_another_way
      end
    end
  end

  def test_heres_still_another_way_to_write_class_methods
    assert_equal :still_another_way, Dog.another_class_method
  end

  # THINK ABOUT IT:
  #
  # The two major ways to write class methods are:
  #   class Demo
  #     def self.method
  #     end
  #
  #     class << self
  #       def class_methods
  #       end
  #     end
  #   end
  #
  # Which do you prefer and why?
  # Are there times you might prefer one over the other?
  #
  # Answer:
  # I prefer self.method because:
  #   1. It's more readable. I can't mistake self.method as being an instance
  #      method, but I can with class << self.
  #   2. Less indentation/nesting.
  # 

  # ------------------------------------------------------------------

  def test_heres_an_easy_way_to_call_class_methods_from_instance_methods
    fido = Dog.new
    assert_equal :still_another_way, fido.class.another_class_method
  end

end
