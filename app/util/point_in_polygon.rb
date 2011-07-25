class PointInPolygon

  def initialize(points)
    @eqs = Array.new
    @polygon = points
    compute_equation
  end

  def compute_equation
    size = @polygon.size - 1  

    (0...size).each do |index|
      x1 = @polygon[index][0] 
      y1 = @polygon[index][1]

      x2 = @polygon[index+1][0] 
      y2 = @polygon[index+1][1]

      @eqs << rect_equation([x1,y1],[x2,y2])
    end

    x1 = @polygon[size][0] 
    y1 = @polygon[size][1]

    x2 = @polygon[0][0] 
    y2 = @polygon[0][1]

    @eqs << rect_equation([x1,y1],[x2,y2])
  end

  def rect_equation(point_a, point_b)
    a = point_a[1] - point_b[1]
    b = point_b[0] - point_a[0]
    c = point_a[0] * point_b[1] - point_b[0] * point_a[1] 

    {:a => a.to_f, :b => b.to_f, :c => c.to_f, :p_a => point_a, :p_b => point_b}
  end

  def collinear_and_between_points?(eq, x, y)
    x1 = eq[:p_a][0]
    x2 = eq[:p_b][0]
    
    y1 = eq[:p_a][1]
    y2 = eq[:p_b][1]

    collinear = (x * eq[:a] + y * eq[:b] + eq[:c]) < 1e-6
    if collinear
      return false unless between(x1, x2, x)
      return false unless between(y1, y2, y)
      return true
    end
    return false
  end

  def between(x, y, z)
    if x > y
      return (x >= z) && (y <= z)
    else
      return (x <= z) && (y >= z)
    end
  end
  

  def rects_contains_point?(point)
    @eqs.each do |eq|
      return true if collinear_and_between_points?(eq, point[0], point[1])
    end
    return false
  end

  def contains_point?(point)
    if rects_contains_point?(point)
      return true
    else
      return contains_point_inside?(point)
    end
  end

  # Algoritmo retirado do site
  # http://jakescruggs.blogspot.com/2009/07/point-inside-polygon-in-ruby.html
  def contains_point_inside?(point)
    c = false
    i = -1
    j = @polygon.size - 1
    while (i += 1) < @polygon.size
      if ( (truncate(@polygon[i][1]) <= truncate(point[1]) && truncate(point[1]) < truncate(@polygon[j][1])) || 
          (truncate(@polygon[j][1]) <= truncate(point[1]) && truncate(point[1]) < truncate(@polygon[i][1])))
       if (truncate(point[0]) < truncate((@polygon[j][0] - @polygon[i][0]) * (point[1] - @polygon[i][1]) / 
            (@polygon[j][1] - @polygon[i][1]) + @polygon[i][0]))
          c = !c
        end
      end
     j = i
    end
    return c
  end

private
  def truncate(number)
    (number*1000000).to_i / 1000000.0
  end
end
