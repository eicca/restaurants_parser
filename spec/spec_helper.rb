require 'rspec'
require 'restaurants_parser'

#def fixture name
  #File.read "fixtures/#{name}"
#end

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
