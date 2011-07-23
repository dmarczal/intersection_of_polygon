describe Set do
  
  before(:each) do
    @set =  Set.new([[1,2], [-2,4], [3,1]]) 
  end

  it "should create set o points" do
    @set.to_a.should == [[1,2], [-2,4], [3,1]]
  end

  it "should sort points by x" do
    @set.sort_by_x.should == [[-2,4], [1,2], [3,1]]
    @set.points.should == [[-2,4], [1,2], [3,1]]
  end

  it "should raise a exception with wrong numbers of points" do
    proc{ Set.new([[1,2], [2, 4] ,[1]]) }.should raise_error("Wrong sequence of numbers")
  end

  it "should return the min x point" do
    @set.sort_by_x
    @set.points.min.should == [-2,4]
  end

  it "should return the max x point" do
    @set.sort_by_x
    @set.points.max.should == [3,1]
  end

  it "should find [0,2764] as min " do
    points = [[0, 2764, 0], [0, 18758, 1], [0, 17199, 2], [120, 100, 3]]

    set = Set.new(points)
    set.points.min.should == [0, 2764, 0]
  end

end
