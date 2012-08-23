require "mechanize"
require "restaurants_parser/version"
require "restaurants_parser/parser"

module RestaurantsParser
  def self.parse(query, options = {})
    p = Parser.new options
    p.parse(query).data
  end
end
