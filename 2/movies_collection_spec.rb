
require './movies_collection'


describe MoviesCollection do

  before :each do
    @temp_file = "temp.yml"
    record = {0 => Movie.new("The Grey", 2011)}
    File.open(@temp_file, "w") do |f| 
      f.write YAML::dump({:mov => record, :fav => []})
    end
    @movies_collection = MoviesCollection.new @temp_file
  end

  describe "#new" do
    context "without yaml file parameter" do
      it "should have no movies" do
        @movies_collection = MoviesCollection.new
        @movies_collection.should have(0).movies
      end
    end

    context "with yaml file parameter" do
      it "should have 1 movie" do
        @movies_collection.should have(1).movies
        File.delete(@temp_file)
      end
    end
  end

  it "should be able to add new movies" do
    @movies_collection.add_movie("Intouchables", 2011)
    @movies_collection.should have(2).movies
  end

  it "should not add same movies as new" do
    @movies_collection.add_movie("Intouchables", 2011)
    @movies_collection.add_movie("Intouchables", 2011)
    @movies_collection.should have(2).movies
  end

  it "should be able to rate movies" do
    @movies_collection.rate_movie(0, 6)
    @movies_collection.movies[0].rating.should == 6
  end

  it "should be able to delete movie" do
    @movies_collection.delete_movie(0)
    @movies_collection.should have(0).movies
  end

  it "should be able to save movies" do
    old_movies = @movies_collection.movies
    @movies_collection.save @temp_file
    new_movies_collection = MoviesCollection.new @temp_file
    new_movies_collection.movies.should == old_movies
  end

  it "should be able to add to favourites" do
    @movies_collection.add_favorite(0)
    @movies_collection.should have(1).favorites
  end
end
