
require './movies_collection'
require 'simplews'


class MoviesCollectionWS < SimpleWS
  def initialize(*args)
    file = args.pop
    super(*args)
    @movies_collection = MoviesCollection.new(file)
  end

  def save
    @movies_collection.save
  end

  serve :getMovies do
    @movies_collection.get_movies
  end

  serve :addMovie, %w(name year), :year => :integer do |name, year|
    @movies_collection.add_movie(name, year)
    "Successfully added new movie"
  end

  serve :rateMovie, %w(movieID rating), 
      :movieID => :integer, :rating => :integer  do |movieID, rating|
    @movies_collection.rate_movie(movieID, rating)
    "Successfully rated movie"
  end

  serve :deleteMovie, %w(movieID), :movieID => :integer do |movieID|
    @movies_collection.delete_movie(movieID)
    "Successfully deleted movie"
  end

  serve :addFavorite, %w(movieID), :movieID => :integer do |movieID|
    @movies_collection.add_favorite(movieID)
    "Successfully added to favorites"
  end

  serve :getFavorites do
    @movies_collection.get_favorites  
  end
end


server = MoviesCollectionWS.new(
    "MoviesCollection", "urs:MoviesCollection", "localhost", "27015", "movies.yml"
)


trap('INT') do
  puts "Stopping server"
  server.shutdown
  server.save
end

require 'soap/header/simplehandler'
class WsseAuthHeader < SOAP::Header::SimpleHandler
  NAMESPACE = 'http://schemas.xmlsoap.org/ws/2002/07/secext'
  USERNAME  = 'username'
  PASSWORD  = 'password'

  def initialize()
    super(XSD::QName.new(NAMESPACE, 'Security'))
  end

  def on_simple_outbound
    {"UsernameToken" => {"Username" => USERNAME, "Password" => PASSWORD}}
  end
end


if $0 == __FILE__
  server.start
end


