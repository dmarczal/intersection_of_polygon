def put_in_order(points)
  points_ordered = Array.new
  can_add = false
  size = 0

  min_point = points.min {|a,b| a[2] <=> b[2]}

  points.each_with_index do |p, i|
    if (p[2] == min_point[2])
      can_add = true
      size = i
    end
    points_ordered << [p[0], p[1]] if can_add
  end

  (0...size).each do |i|
    points_ordered << [points[i][0], points[i][1]]
  end

  points_ordered
end


