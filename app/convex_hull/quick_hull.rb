require './app/convex_hull/segment'
require './app/convex_hull/set'
require './app/convex_hull/util'

class QuickHull

  def initialize(points)
    @set = Set.new(points)
    @set.sort_by_x
  end

  def find
    if @set.points.size > 2
      min = @set.points.first
      max = @set.points.last
      
      sgt_up = Segment.new(min, max, @set.points)
      sgt_down = Segment.new(max, min, @set.points)
    
      pa = quick_hull(sgt_up)
      pb = quick_hull(sgt_down)
 
      if pa.map{|a| a[0..1]} == pb.map{|a| a[0..1]}
        hull = pa
      else
        hull = remove_collinear(pa, pb)
        hull = remove_collinear(hull[0..-3], hull.last(2))
      end
 
      put_in_order(hull)
    else
      @set.points.map{|a| a[0..1]}.uniq
    end
  end

  def quick_hull(segment)
     most_distante = segment.most_distante
     points_over = segment.points_over
     
     hull = Array.new

     if (most_distante.empty?) # se não tiver mais pontos "acima" da reta, a reta faz parte do fecho convexo
       [segment.point_a]
     else
         pa = quick_hull(Segment.new(most_distante, segment.point_b, points_over))
         
         pb = quick_hull(Segment.new(segment.point_a, most_distante, points_over))
         
         remove_collinear(pa, pb)
     end
  end

  def remove_collinear(pa, pb)
    if (pb.size >= 2 && pa.size > 0 && is_collinear(pb[0], pb[1], pa[-1]))
        pb.delete_at 0
    end
   
    if (pa.size >= 2 && pb.size > 0 && is_collinear(pb[0], pa[-1], pa[-2]))
        pa.pop
    end

    pa + pb
  end

  def is_collinear(p, p1, p2)
    a = p[1] - p1[1]
    b = p1[0] - p[0]
    c = p[0] * p1[1] - p1[0] * p[1]

    x = p2[0]
    y = p2[1]
    (x * a + y * b + c) == 0
  end
end
