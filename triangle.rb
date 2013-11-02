# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
  #
  # My first solution
  #
  # # Test that the triangle is valid
  # # No side can be <= 0
  # raise TriangleError if a <= 0 || b <= 0 || c <= 0
  # # Sum of any two sides must be > third side
  # raise TriangleError if a >= b+c || b >= a+c || c >= a+b

  # return :equilateral if a == b && b == c
  # return :isosceles if a == b || b == c || a == c
  # return :scalene
  #

  #
  # The Stack Overflow assisted version
  #

  # Sort the triangle sides in ascending order such that a is the smallest
  a, b, c = sides = [a, b, c].sort

  # If a <= 0
  raise TriangleError if a <= 0 || a + b <= c
  # Slightly easier to read version:
  # raise TriangleError unless a > 0 || a + b > c

  # Find out how many unique lengths there are. If 1, return :equilateral; if
  # 2, return :isoceles; if 3, return :scalene. Note the clever usage of the
  # negative indexing into the array to directly map the number of unique sides
  # to the type of triangle without needing to pad the array
  [:scalene, :isosceles, :equilateral][-sides.uniq.size]
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
