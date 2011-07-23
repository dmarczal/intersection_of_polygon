require './app/convex_hull/segment'

describe Segment do

  before(:each) do
    @points = [[3,4],[1,4],[2,2],[1,1]]
    @a = [-1,3]
    @b = [4,2]
    @sg = Segment.new(@a, @b, @points)
  end

  it "should create a segment with two points" do
    @sg.to_a.should == [[-1,3],[4,2]] 
  end

  it "should calcule a distance of a point to the segment" do
    sg = Segment.new([1,2], [3,1], @points)
    sg.distance([2,3]).should == 3
    sg.distance([8,3]).should == 9

    @sg.distance([3,4]).should == 9
  end

  it "should find the most distante point from the segment" do
    @sg.most_distante.should == [3,4]
  end

  it "should return [] if there is not most distante point from the segment that it > 0" do
    points = [[-2,1],[2,-2],[2,2],[1,1]]
    Segment.new(@a,@b, points).most_distante.should == []
  end

  it "should return the points over the segment that the distance is > 0" do
    @sg.points_over.should == [[3,4],[1,4]]
  end

  it "should return [] if there is no points over it" do
    points = [[-2,1],[2,-2],[2,2],[1,1]]
    Segment.new(@a,@b, points).points_over.should == []   
  end
end
