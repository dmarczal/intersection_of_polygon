require "./app/util/util"
require 'rational'

class Duality

  def initialize(points = [])
    @points = points
  end

  # given two points this method
  # returns the a b c of rect equation
  # equação da Reta 
  # = x(y1 – y2) + y(x2 – x1) + (x1y2 – x2y1)
  # y = mx + c
  def rect_equation(point_a, point_b)
    # equação da reta que contain os pontos a e b
    a = point_a[1] - point_b[1]
    b = point_b[0] - point_a[0]
    c = point_a[0] * point_b[1] - point_b[0] * point_a[1] 
    #puts "#{a}x + #{b}y + #{c} = 0"

    {:a => a.to_f, :b => b.to_f, :c => c.to_f}
  end

  # Given a rect
  # it returns a rect perndicular and that
  # pass through point P(0,0)
  # y - y0 = m(x-x0)
  # y - 0  = m(x-0)
  # y = mx
  # y = b / a * x
  # b/a*x -y = 0
  # return m of y = m*x
  def rect_perpendicular(rect)
    # coeficiente de rect
    #c = -rect[:a].to_f / rect[:c].to_f
    # coeficiente da reta perpendicular é o inverso e o oposto
    rect[:b] / rect[:a]
  end

  # determina o ponto de interseção da reta dada a reta
  # perpendicular que passa pelo ponto P(0,0)
  def point_of_intersection(rect)
    # reta horizontal
    if rect[:a] == 0
      x =  0
      y =  -rect[:c] / rect[:b]
    # reata vertical  
    elsif rect[:b] == 0
      y = 0
      x = -rect[:c] / rect[:a]
    else
      x =  rect[:c] / rect[:b] / (- rect[:a] / rect[:b] - rect[:b] / rect[:a])
      y =  rect[:b] / rect[:a] * x
    end
    [x, y]
  end

  # Given a point P(x,y) it return the distance between point P(0,0)
  # and given point
  # d² = (x2-x1)² + (y2 - y1)²
  # d² = (x2-0)² + (y2 - 0)²
  # d² = x² + y² 
  #TODO: verificar operador ** 
  def distance_of_point_zero(point)
    Math.sqrt(point[0].abs**(2) + point[1].abs**(2))
  end
   
  #TODO: verificar operador ** 
  def dual_by_point(point)
    divisor = (point[0].abs**2 + point[1].abs**2)
    if divisor != 0
      x = - point[0] / divisor
      y = - point[1] / divisor
    else
      x = 0.0
      y = 0.0
    end
    [x, y]
  end

  # calcula a dualidade de uma reta 
  # utilizando a formula da equação da reta 
  def dual(point_a, point_b)
    eq = rect_equation(point_a, point_b)
    point = point_of_intersection(eq)
  
    dual_by_point(point)
  end

  # Retorna o dual de todas 
  # as linhas do pontos unindo os pontos 
  # dois a dois seguindo sua sequência
  def duals_lines
    size = @points.size - 1
    duals = []

    (0...size).each do |index|
      x1 = @points[index][0] 
      y1 = @points[index][1]
      
      x2 = @points[index+1][0] 
      y2 = @points[index+1][1]
      
      duals.push dual([x1, y1], [x2, y2])
      #p "x1: #{x1} y1: #{y1} x2: #{x2} y2: #{y2} "
    end
    
    x1 = @points[size][0] 
    y1 = @points[size][1]

    x2 = @points[0][0] 
    y2 = @points[0][1]
      
    duals.push dual([x1, y1], [x2, y2])
    duals
  end
  
end
