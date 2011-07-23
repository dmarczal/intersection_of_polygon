# encoding:  utf-8 

require "wx"
require "app/view/draw_polygon"
require "app/reader/file_reader"

require "app/convex_hull/quick_hull"
require "app/duality/duality"
require "app/util/util"

class IntersectionFrame < Wx::Frame

  include FileReader

  def initialize
    super(nil, :title=>"Intersecção de Polígonos Convexos", :size=>[700,500])
    
    @points = read
    intersection
    # Start creating the sashes - these are created from outermost
    # inwards. 
    sash = Wx::SashLayoutWindow.new(self, -1, Wx::DEFAULT_POSITION,
                                    Wx::Size.new(166, self.get_size.y))

    # The default width of the sash is 1750 pixels, and it extends the
    # full height of the frame
    sash.set_default_size( Wx::Size.new(166, self.get_size.y) )

    # This sash splits the frame top to bottom
    sash.set_orientation(Wx::LAYOUT_VERTICAL)

    # Place the sash on the left of the frame
    sash.set_alignment(Wx::LAYOUT_LEFT)
    
    # Show a drag bar on the right of the sash
    sash.set_sash_visible(Wx::SASH_RIGHT, true)
    sash.set_background_colour(Wx::Colour.new(225, 200, 200) )

    panel = Wx::Panel.new(sash)
    panel.set_background_colour(Wx::WHITE)
    v_siz = Wx::StaticBoxSizer.new( Wx::VERTICAL, panel, 'Opções') 

    types = ['Polígono A', 'Polígono B', 'Dual(A)', 'Dual(B)', 'Dual(A) U Dual(B)', 'F(Dual(A) U Dual(B))', 'Dual(F(Dual(A)UDual(B)))']
    
    my_font = Wx::Font.new
    my_font.set_point_size(7)
    my_font.set_family(Wx::FONTFAMILY_MODERN)
    #my_font.set_style(Wx::FONTSTYLE_ITALIC) 
    my_font.set_weight(Wx::FONTWEIGHT_BOLD)



    types.each_with_index do |value, index|
       p_a = Wx::CheckBox.new(panel, -1, value)
       p_a.set_value(true)
       p_a.set_foreground_colour(@polygon_panel.color(index))
       p_a.set_font(my_font) 

       evt_checkbox(p_a) do |event|
          on_check_box(index)
       end
       v_siz.add(p_a, 0, Wx::ADJUST_MINSIZE)
    end
       
    panel.set_sizer_and_fit(v_siz)
    # handle the sash being dragged
    evt_sash_dragged( sash.get_id ) { | e | on_v_sash_dragged(sash, e) }


    evt_size { | e | on_size(e) }
    Wx::LayoutAlgorithm.new.layout_frame(self, @polygon_panel)
  end

  def on_check_box(index)
    @polygon_panel.show_or_not(index)
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
  
    union_dual.each_with_index { |point, index| point << index }

    fecho_convexo = QuickHull.new(union_dual).find
    dual_fecho = Duality.new(fecho_convexo).duals_lines
     
    union_dual.each { |point| point.delete_at 2 }

    @polygon_panel = DrawPolygon.new(self, @points[1], @points[2], dual_a, dual_b, union_dual, fecho_convexo, dual_fecho )
  end
end

class Main < Wx::App
  def on_init
   IntersectionFrame.new.show
  end
end


