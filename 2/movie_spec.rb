
require './movie'


describe Movie do

  before :all do
    @movie = Movie.new "Hugo", 2011
  end

  describe "#new" do
    it "should take 2 parameters and return 'Movie' object" do
      @movie.should be_instance_of Movie
    end
  end

  describe "#name" do
    it "should return correct movie name" do
      @movie.name.should == "Hugo"
    end
  end

  describe "#year" do
    it "should return correct movie year" do
      @movie.year.should == 2011
    end
  end

  it "rating should be 'n/a' when first created" do
    @movie.rating.should == "n/a"
  end

  it "should allow to rate" do
    @movie.rate 5
    @movie.rating.should == 5
  end

  it "should not allow to rate with negative or greater than 10 values" do
    lambda {
        @movie.rate 11
    }.should raise_error "Cannot rate with negative or greater than 10 values"
  end

  it "should rate correctly" do
    @movie.rate 8
    @movie.rating.should == 6.5
  end

end
