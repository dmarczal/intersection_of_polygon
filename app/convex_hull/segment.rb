class Segment
 
  attr_reader :point_a, :point_b, :points_over, :most_distante

  def initialize(a, b, points)
    @point_a = a
    @point_b = b
    
    straight_equation   
    compute_points(points)
  end
  
  # Calcula a distância entre um reta r e um ponto p
  # utilizando a formula da equação da reta 
  # eqReta = x(y1 – y2) + y(x2 – x1) + (x1y2 – x2y1)

  # Como não necessitamos obter o valor exato para a distância por que
  # apenas utilizaremos para determinar o ponto mais distante omitiremos
  # a divisão do cálculo da distância

  # Equação da distância
  # drq = ( x(y1 – y2) + y(x2 – x1) + (x1y2 – x2y1) )/ sqrt ( (y1-y2)^2 + (x2-x1)^2 )

  # Equação utilizada
  # drq = ( x(y1 – y2) + y(x2 – x1) + (x1y2 – x2y1) )
  def distance(p)
    x = p[0]
    y = p[1]
    x * @a + y * @b + @c 
  end

  def to_a
    [@point_a, @point_b]
  end

private 
  def compute_points(points)
    #distances = points.map {|a| distance(a)}
    distances = []
    @points_over = []
    indexs_over = []
     points.each_with_index do |p, i|
      d = distance(p)
      if d > 1e-10
         @points_over << p
         indexs_over << i
      end
      
      distances << d
    end
   max_index = indexs_over.max {|a,b| distances[a] <=> distances[b]}

   @most_distante = max_index ? points[max_index] : []
  end
  
  def straight_equation
    @a = @point_a[1] - @point_b[1]
    @b = @point_b[0] - @point_a[0]
    @c = @point_a[0] * @point_b[1] - @point_b[0] * @point_a[1] 
  end
end
