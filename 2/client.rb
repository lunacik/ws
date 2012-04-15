require 'soap/wsdlDriver'

server = SOAP::WSDLDriverFactory.new("moviesCollection.wsdl").create_rpc_driver 

server.addMovie("Melancholia", 2011)
#server.addMovie("Parselis", 2000)

server.rateMovie(1, 10)
#server.rateMovie(2, 10)
#server.rateMovie(3, 7)


#movies = server.getMovies
#print movies

#server.deleteMovie(1)
server.addFavorite(2)
server.addFavorite(1)
puts server.getFavorites
#movies = server.getMovies


#puts movies
