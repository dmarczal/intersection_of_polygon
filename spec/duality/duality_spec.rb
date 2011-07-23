require './app/duality/duality'

describe Duality do
  
  before(:each) do
    @dual = Duality.new
  end

  it "should calculate the rect equation" do
    @dual.rect_equation([-2, 0],[0, 2]).should == {:a => -2.0, :b => 2.0, :c => -4.0}
    @dual.rect_equation([0, 0],[-1, 1]).should == {:a => -1.0, :b => -1.0, :c => 0.0}
  end

  it "should determinate the rect perpendicular a given rect that pass through P(0,0) " do
    rect = {:a => -2.0, :b => 2.0, :c => -4.0}
    @dual.rect_perpendicular(rect).should == -1
  end

  it "should determinate the point P(x,y) perpendicular a rect tha pass through P(0,0) " do
    rect = {:a => -2.0, :b => 2.0, :c => -4.0}
    @dual.point_of_intersection(rect).should == [-1.0, 1.0]
  end

  it "shuld determine de distance beteween point P(0,0) e a given point" do
    @dual.distance_of_point_zero([-1.0, 1.0]).should == 1.4142135623730951
  end
  
  it "shuld determine the dual of point distance beteween point P(0,0) e a given point" do
    @dual.dual_by_point([-1.0, 1.0]).should == [0.5,-0.5]
    @dual.dual_by_point([0, 1.0]).should == [0,-1.0]
  end

  it "shuld determine the dual of a rect given to points" do
    @dual.dual([-2.0, 0.0],[0.0,2.0]).should == [0.5,-0.5]
  end
end
