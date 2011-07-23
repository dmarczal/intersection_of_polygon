require './app/convex_hull/quick_hull'

describe QuickHull do
  
  def should_be_equal(points, result)
    qh = QuickHull.new(points)
    qh.find.should == result
  end 
  
  it "should find the convex hull for 5 points that makes a square" do
    points = [[0, 10, 0], [10, 0, 1], [5, 5, 2], [0, 0, 3], [10, 10, 4]]
    sl = [[0, 10], [0, 0], [10, 0], [10,10]]

    should_be_equal(points, sl)
  end

  it "should find the convex hull in anti hour sequence" do
    points = [[10, 10, 4], [0, 10, 1], [10, 0, 2],[9, 0, 2], [5, 5, 3], [0, 0, 0], [0, 1, 4]]
    sl = [[0, 0], [10, 0], [10, 10], [0, 10]] 

    should_be_equal(points, sl)
  end

  it "should find convex hull for collinear points [10, 20, 0], [30, 40, 1], [20, 30, 2] ]" do
    points = [[10, 20, 0], [30, 40, 1], [20, 30, 2]]
    sl = [[10, 20], [30, 40]] 

    should_be_equal(points, sl)
  end

  it "should find convex hull for [10, 20, 0], [30, 40, 1], [20, 30, 2], [30, 22] ]" do
    points = [[10, 20, 0], [30, 40, 1], [20, 30, 2], [30,22, 3]]
    sl = [[10, 20], [30, 22],[30, 40]] 

    should_be_equal(points, sl)
  end

  it "should return one point for iguals points" do
    points = [[10, 20, 0], [10, 20, 1], [10, 20, 2], [10, 20, 3]]
    sl = [[10, 20]] 

    should_be_equal(points, sl)
  end

  it "should return [[10, 20], [30, 40]] for [[10, 20], [30, 40]]" do

    points = [[10, 20, 0], [30, 40, 1]]
    sl = [[10, 20], [30, 40]] 

    should_be_equal(points, sl)
  end

  it "should find convex hull for [10, 20], [10, 20] ]" do
    points = [[10, 20, 0], [10, 20, 1]]
    sl = [[10, 20]] 

    should_be_equal(points, sl)
  end

  it "should find the convex hull" do
     points = [[3,9],[11,1],[6,8],[4,3],[5,15],[8,11],[1,6],[7,4],[9,7],[14,5],[10,13],[17,14],[15,2],[13,16],[3,12],[12,10],[16,8]]
     sl = [[11,1],[15,2],[17,14],[13,16],[5,15],[3,12],[1,6],[4,3]]
     
     points.each_with_index {|p, i| p << i}  

    should_be_equal(points, sl)
  end
end
