require 'lib/quick_hull'

class ConvexHull

  def find_by_quick_hull(points)  
    QuickHull.new(points).find
  end

end

