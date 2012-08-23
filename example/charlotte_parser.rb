$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "restaurants_parser"

query = 'http://www.restaurants.com/north-carolina/charlotte'
p RestaurantsParser::parse(query, deep: 2, debug: true)
