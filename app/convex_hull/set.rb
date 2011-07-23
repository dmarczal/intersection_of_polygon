require 'enumerator'

class Set
   
  attr_reader :array_points, :points

  def initialize(array_points)
    array_points.each{|point| raise "Wrong sequence of numbers" if point.length < 2}
    @points = array_points
  end
  
  def to_a
    @points 
  end

  def sort_by_x
    @points.sort!{|a,b| a[0] <=> b[0]}
  end

end
