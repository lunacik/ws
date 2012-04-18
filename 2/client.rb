
require 'soap/wsdlDriver'



class UI
  def initialize(wsdl)
    @client = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver 
    loopMenu
  end

  def loopMenu
    while true
      begin
        printMenu
        case gets.chomp
          when "1" then
            print_movies(@client.getMovies)
            idle
          when "2" then 
            puts "Enter movie name"
            name = gets.chomp
            puts "Enter movie year"
            year = gets.chomp.to_i
            puts @client.addMovie(name, year)
            idle
          when "3" then
            puts "Enter movie id"
            id = gets.to_i
            puts @client.deleteMovie(id)
            idle
          when "4" then
            puts "Enter movie id"
            id = gets.to_i
            puts "Enter rating(1..10)"
            rating = gets.to_i
            puts @client.rateMovie(id, rating)
            idle
          when "5" then
            print_movies(@client.getFavorites)
            idle
          when "6" then
            puts "Enter movie id"
            id = gets.to_i
            puts @client.addFavorite(id)
            idle
          when "7" then
            puts "Good bye..."
            break
          else
            puts "Invalid input! Choose between 1 and 7"
            idle
          end
      rescue Exception => e
        puts e
        idle
      end
    end
  end

  def printMenu
    print `clear`
    puts "Welcome to Movies Collection!"
    puts "1 - see all movies"
    puts "2 - to add new movie"
    puts "3 - to delete movie"
    puts "4 - to rate movie"
    puts "5 - to see all favorites"
    puts "6 - to add movie to favorites"
    puts "7 - to quit"
  end

  def idle
    puts "Press enter to continue..."
    gets
  end

  def print_movies(movies)
    if movies == []
      puts "No records"
    else
      puts format("ID", 5) + format("Name", 30) + format("Year", 10) + "Rating"
      movies.each do |movie|
        print format(movie.shift, 5)
        print format(movie.shift, 30)
        print format(movie.shift, 12)
        puts movie.shift
      end
    end
  end

  def format(string, spaces)
    string = string.to_s
    return string if spaces - string.length <= 0
    string + " " * (spaces - string.length)
  end

end


UI.new "moviesCollection.wsdl"
