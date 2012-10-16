
require 'savon'

#HTTPI.log = false
Savon.configure do |config|
#  config.log = false      
#  config.log_level = :error
end



class UI
  def initialize(wsdl)
    @wsdl = wsdl
    prompt_menu
  end

  def prompt_menu
  while true
    print `clear`
    puts "1 - to login"
    puts "2 - to register"
    puts "3 - quit"
    case gets.chomp
      when "1" then
        print `clear`
        puts "Enter your username"
        username = gets.chomp
        puts "Enter your password"
        password = gets.chomp
        @client = Savon::Client.new @wsdl
        @client.wsse.credentials username, password, :digest
        if @client.request(:check_if_registered).to_hash[:check_if_registered_response][:return]
            loop_menu
        else
            puts "Wrong username or password"
            idle
        end
      when "2" then
        puts "Enter your fullname"
        fullname = gets.chomp
        puts "Enter your username"
        username = gets.chomp
        puts "Enter your password"
        password = gets.chomp
        @client = Savon::Client.new @wsdl
        @client.wsse.credentials "guest", "guest"
        resp = @client.request :register, body: {"fullname" => fullname, "username" => username, "password" => password}
        puts resp.to_hash[:register_response][:return]
        idle
      when "3" then
          break
      else
          puts "Invalid input! Choose between 1 and 3"
          idle
      end
    end
  end



  def loop_menu
    while true
      begin
        printMenu
        case gets.chomp
          when "1" then
            print_movies(@client.request :get_movies)
            idle
          when "2" then 
            puts "Enter movie name"
            name = gets.chomp
            puts "Enter movie year"
            year = gets.chomp.to_i
            puts @client.request(:add_movie, body: {"name" => name, "year" => year}).to_hash[:add_movie_response][:return]
            idle
          when "3" then
            puts "Enter movie id"
            id = gets.to_i
            puts @client.request(:delete_movie, body: {"movieID" => id}).to_hash[:delete_movie_response][:return]
            idle
          when "4" then
            puts "Enter movie id"
            id = gets.to_i
            puts "Enter rating"
            rating = gets.to_i
            puts @client.request(:rate_movie, body: {"movieID" => id, "rating" => rating}).to_hash[:rate_movie_response][:return]
            idle
          when "5" then
            puts "Good bye..."
            break
          else
            puts "Invalid input! Choose between 1 and 5"
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
    puts "5 - to logout"
  end

  def idle
    puts "Press enter to continue..."
    gets
  end

  def print_movies(movies_resp)
    movies = movies_resp.to_hash[:get_movies_response][:return].collect {|movie| movie[:array]}
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



UI.new "http://localhost:8080/PersonalMoviesCollection/services/PMC_Server?wsdl"




