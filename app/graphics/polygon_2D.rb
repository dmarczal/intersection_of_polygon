class Polygon2D
  
  def initialize(points, offset, scale=1)
    @points = points
    @scale = scale
    @offset = offset
  end

  def path(gdc)
    path = gdc.create_path

    #puts "center.x: #{@offset.x} center.y: #{@offset.y}"

    @points.each do |point|
      x = @offset.x + point[0]*@scale 
      y = y_coord(point[1])
      #puts "0: #{point[0]} 1: #{point[1]}"
      #puts "x: #{x} y: #{y}"
      path.add_line_to_point(x, y)
    end

    x = @scale*@points.first[0] + @offset.x 
    y = y_coord @points.first[1]
    path.add_line_to_point(x, y)
    
    path
  end
private
  def y_coord(y)
     y < 0 ? -1*y*@scale + @offset.y : @offset.y - y*@scale
  end
end
