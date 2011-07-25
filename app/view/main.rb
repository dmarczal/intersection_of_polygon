# encoding:  utf-8 

require "wx"
require "app/view/draw_polygon"
require "app/reader/file_reader"

require "app/convex_hull/quick_hull"
require "app/duality/duality"
require "app/util/util"
require "app/util/point_in_polygon"

class IntersectionFrame < Wx::Frame

  include FileReader

  OPTION_SIZE = 166

  def initialize
    super(nil, :title=>"Intersecção de Polígonos Convexos", :size=>[700,500])
    read_polygons_and_calculate
    create_options        
  end

  def on_size(e)
    e.skip()
    Wx::LayoutAlgorithm.new.layout_frame(self, @polygon_panel)
    @polygon_panel.refresh if @polygon_panel
  end

  def on_v_sash_dragged(sash, e)
    # Call get_drag_rect to get the new size
    size = Wx::Size.new(  e.get_drag_rect.width(), self.get_size.y )
    sash.set_default_size( size )
    Wx::LayoutAlgorithm.new.layout_frame(self, @polygon_panel)
  end

  def intersection
    dual_a = Duality.new(@points[1]).duals_lines
    dual_b = Duality.new(@points[2]).duals_lines
   
    union_dual = dual_a + dual_b
    union_dual = order_by_anti_clock_wise(union_dual)

    union_dual_clone = clone_points_add_index(union_dual)
    
    fecho_convexo = QuickHull.new(union_dual_clone).find
    dual_fecho = Duality.new(fecho_convexo).duals_lines
    
    @polygon_panel = DrawPolygon.new(self, @points[1], @points[2],
                                     dual_a, dual_b, union_dual,
                                     fecho_convexo, dual_fecho )

    if ARGV[0].eql? "--show_points"
      print_polygon_if_it_is_the_intersection(dual_fecho)
    end
  end
private
  def create_options
    # Start creating the sashes - these are created from outermost
    # inwards. 
    sash = Wx::SashLayoutWindow.new(self, -1, Wx::DEFAULT_POSITION,
                                    Wx::Size.new(OPTION_SIZE, self.get_size.y))

    sash.set_default_size( Wx::Size.new(OPTION_SIZE, self.get_size.y) )

    # This sash splits the frame top to bottom
    sash.set_orientation(Wx::LAYOUT_VERTICAL)

    # Place the sash on the left of the frame
    sash.set_alignment(Wx::LAYOUT_LEFT)
    
    sash.set_sash_visible(Wx::SASH_RIGHT, true)
    sash.set_background_colour(Wx::Colour.new(225, 200, 200))
    
    panel = Wx::Panel.new(sash)
    panel.set_background_colour(Wx::WHITE)
    v_siz = Wx::StaticBoxSizer.new( Wx::VERTICAL, panel, 'Opções') 

    types = ['Polígono A', 'Polígono B', 'Dual(A)', 'Dual(B)',
             'Dual(A) U Dual(B)', 'F(Dual(A) U Dual(B))', 'Dual(F(Dual(A)UDual(B)))']
    
    types.each_with_index do |value, index|
       c = create_check_box(panel, value, index)
       v_siz.add(c, 0, Wx::ADJUST_MINSIZE)
    end

    scale_text =  StaticText.new(panel, -1, " Scale Zoom: ")
    v_siz.add(scale_text, 0, Wx::ADJUST_MINSIZE)

    zoom_x = ["1", "2", "4", "6", "8", "10"]
    ch = Wx::Choice.new(panel, -1, Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE, zoom_x)
    v_siz.add(ch, 0, Wx::ADJUST_MINSIZE)

    zoom_text =  StaticText.new(panel, -1, " Zoom: ")
    v_siz.add(zoom_text, 0, Wx::ADJUST_MINSIZE)
    
    slider = Wx::Slider.new(panel, 100, 0, -100, 100, Wx::DEFAULT_POSITION, Wx::Size.new(150,-1),
                            Wx::SL_VERTICAL | Wx::SL_AUTOTICKS | Wx::SL_LABELS)

    slider.set_tick_freq(5,1)

    v_siz.add(slider, 10, Wx::ADJUST_MINSIZE)
    
    evt_slider(slider) do |e|
      @polygon_panel.zoom= slider.get_value * zoom_x[ch.get_selection].to_i
      @polygon_panel.refresh
    end

    panel.set_sizer_and_fit(v_siz)
    
    evt_sash_dragged( sash.get_id ) { | e | on_v_sash_dragged(sash, e) }

    evt_size { | e | on_size(e) }
    Wx::LayoutAlgorithm.new.layout_frame(self, @polygon_panel)
  end

  def read_polygons_and_calculate
    @points = read
    intersection
  end

  def create_check_box(parent, value, index)
    c = Wx::CheckBox.new(parent, -1, value)
    c.set_value(true)
    c.set_foreground_colour(@polygon_panel.color(index))
    c.set_font(font) 

    evt_checkbox(c) do |event|
      on_check_box(index)
    end
    c
  end

  def font
    f = Wx::Font.new
    f.set_point_size(7)
    f.set_family(Wx::FONTFAMILY_MODERN)
    f.set_weight(Wx::FONTWEIGHT_BOLD)
    f
  end

  def on_check_box(index)
    @polygon_panel.show_or_not(index)
  end

  def print_polygon_if_it_is_the_intersection(dual_fecho)
    point_inside = PointInPolygon.new(@points[1])
    # verifica se o polígono é realmente a intersecção
    dual_fecho.each do |point|
     return false unless point_inside.contains_point?(point)
    end
    print_polygon(dual_fecho)
  end

  def print_polygon(points)
    points.each do |point|
      puts "#{point[0]} #{point[1]}"  
    end
  end
end

class Main < Wx::App
  def on_init
   IntersectionFrame.new.show
  end
end


