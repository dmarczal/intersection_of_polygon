# encoding: UTF-8
require 'app/graphics/polygon_2D'
require "wx"
include Wx

class DrawPolygon < Wx::Panel
  
  COLOURS = [Wx::Colour.new("RED"), Wx::Colour.new("BLUE"),
             Wx::Colour.new("DARK RED"), Wx::Colour.new("DARK BLUE"),
             Wx::Colour.new("DARK GREEN"), Wx::Colour.new("DARK GRAY"),
             Wx::Colour.new("BLACK"), Wx::Colour.new("YELLOW")]
    
  def initialize(parent, *points)
    super(parent, -1)
    @points = points
    @not_show = []
    @zoom = 0
    set_background_colour(Wx::WHITE)
    self.run_draw
  end
  
  def calculate_center_point(dc)
    @width = dc.size.width/2
    @height = dc.size.height/2
    @center = Wx::Point.new(@width, @height)
  end

  def zoom=(zoom)
    @zoom = zoom
  end

  # Determina quantos pixels o polígono deve
  # ser ampliado
  def enlarge
    p = @points.flatten
    bigger = [p.max, p.min.abs].max
    
    min_between_h_w = [@width, @height].min
    half = min_between_h_w/2

    if bigger > half
      enlarge = 1
    else
      enlarge = (min_between_h_w/bigger.to_f)
    end
    enlarge       
  end

  def draw_polygons(gdc)
    eg = enlarge
    @points.each_with_index do |polygon, index|
      unless @not_show.include? index
        pen_color(index, gdc)
        p = Polygon2D.new(polygon, @center, @zoom, eg)
        gdc.draw_path(p.path(gdc))  
      end
    end
  end

  def pen_color(index, gdc)
   gdc.set_pen Wx::Pen.new(COLOURS[index])
  end

  def color(index)
    COLOURS[index]
  end

  def run_draw
    evt_paint() do
      self.paint do |dc|

        calculate_center_point(dc)
        dc.cross_hair(@center.x, @center.y)

        gdc = Wx::GraphicsContext.create(dc)
        gdc.set_pen Wx::BLACK_PEN
        
        draw_polygons(gdc)
      end
    end
    show()
  end 

  def show_or_not(index)
    if @not_show.include? index
      @not_show.delete index
    else
      @not_show << index
    end
    refresh
  end

end

