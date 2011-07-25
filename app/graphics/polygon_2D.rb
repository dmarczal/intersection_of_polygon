class Polygon2D
  
  def initialize(points, offset, zoom, scale=1)
    @points = points
    @scale = scale
    @offset = offset
    @zoom = zoom
  end

  def path(gdc)
    path = gdc.create_path

    #puts "center.x: #{@offset.x} center.y: #{@offset.y}"

    @points.each do |point|
      #x = @offset.x + point[0]*(@scale+@zoom)
      x = @offset.x + scale(point[0])
      y = y_coord(point[1])
      #puts "0: #{point[0]} 1: #{point[1]}"
      #puts "x: #{x} y: #{y}"
      path.add_line_to_point(x, y)
    end

    #x = @offset.x + @points.first[0]*(@scale+@zoom)
    x = @offset.x + scale(@points.first[0])
    y = y_coord @points.first[1]
    path.add_line_to_point(x, y)
    
    path
  end
private
  def y_coord(y)
     #y < 0 ? -1*y*(@scale+@zoom) + @offset.y : @offset.y - y*(@scale+@zoom)
     y < 0 ? -1*scale(y) + @offset.y : @offset.y - scale(y)
  end
  
  def scale(point)
    s = @scale + @zoom
    if s < 0
      return point / s.abs.to_f
    else
      return point * s.abs
    end
  end
end
