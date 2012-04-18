
require "yaml"
require "./movie"

$MOVIES_FILE = "movies.yml"



class MoviesCollection
  attr :movies, :favorites

  def initialize(movies_file=false)
    @movies_file = movies_file
    if @movies_file
      data = YAML::load_file(@movies_file)
      if data[:mov]
        @movies = data[:mov]
      else
        @movies = {} 
      end
      if data[:fav]
        @favorites = data[:fav]
      else
        @favorites = []
      end 
    else
      @movies = {}
      @favorites = []
    end
  end

  def new_id(ids=@movies.keys)
    if ids == []
      1 
    else
      1.upto(ids.max + 1) do |id| 
        if not ids.include?(id)
          return id 
        end
      end
    end
  end

  def add_movie(name, year)
    new_movie = Movie.new(name, year)
    @movies.values.each do |movie| 
      return if movie.name == new_movie.name and movie.year == new_movie.year
    end
    @movies[new_id] = new_movie
  end

  def rate_movie(id, rating)
    raise "Cannot rate nonexistend movie" unless @movies[id]
    @movies[id].rate(rating)
  end

  def get_movies
    movies.collect {|key, movie| [key, movie.name, movie.year, movie.rating.to_s]}
  end

  def delete_movie(id)
    raise "Cannot delete nonexistent movie" unless @movies[id]
    @favorites.delete(id)
    @movies.delete(id)
  end

  def add_favorite(id)
    raise "Movie doesnt exist" unless @movies[id]
    @favorites.push(id) unless @favorites.include? id
  end

  def get_favorites
    @favorites.collect do |id|
     movie = @movies[id]
     [id, movie.name, movie.year, movie.rating.to_s]
    end
  end

  def save(movies_file=false)
    @movies_file = movies_file || @movies_file || $MOVIES_FILE
    File.open(@movies_file, "w") do |f|
      f.write YAML::dump({:mov => @movies, :fav => @favorites})
    end
  end
end
