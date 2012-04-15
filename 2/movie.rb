
require 'date'

class Movie
  attr :name, :year, :rating

  def initialize(name, year)
    raise "Cannot create movie without name" if name == ""
    raise "Wrong year specified" if year > Date.today.year or year < 1900
    @name = name
    @year = year
    @ratings = []
    @rating = "n/a"
  end

  def rate(rating)
    if rating > 10 or rating < 1
      raise "Cannot rate with negative or greater than 10 values"
    end
    @ratings.push(rating)
    @rating = average.round(1)
  end

  def ==(other)
    self.instance_variables.each do |ivar| 
      return false if self.instance_variable_get(ivar) != other.instance_variable_get(ivar)
    end
  end

  def average
    sum = 0
    @ratings.each {|rating| sum += rating}
    sum.to_f / @ratings.size
  end
end
