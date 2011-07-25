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

def order_by_anti_clock_wise(points)
  quadrant_1 = []
  quadrant_2 = []
  quadrant_3 = []
  quadrant_4 = []

  points.each do |point|
    if point[0] > 1e-10 && point[1] > 1e-10
      quadrant_2 << point
    elsif point[0] < 1e-10 && point[1] > 1e-10
      quadrant_1 << point
    elsif point[0] < 1e-10 && point[1] < 1e-10
      quadrant_3 << point
    else
      quadrant_4 << point
    end
  end
  quadrant_1.sort! {|p1, p2| compare(p1, p2)}
  quadrant_2.sort! {|p1, p2| compare(p1, p2)}
  quadrant_3.sort! {|p1, p2| compare(p1, p2)}
  quadrant_4.sort! {|p1, p2| compare(p1, p2)}
  
  quadrant_1.reverse + quadrant_3 + quadrant_4 + quadrant_2
end

def compare(p1, p2)
  return -1 if p2[0] == 0
  return  1 if p2[1] == 0
  a = p1[0] != 0.0 ? p1[1].to_f/p1[0].to_f : p1[0]
  b = p2[0] != 0.0 ? p2[1].to_f/p2[0].to_f : p2[0]
  a <=> b
end

def clone_points_add_index(points)
  clone = []
  points.each_with_index do |element, index|
    c = element.clone
    clone << c.push(index)
  end
  clone
end
