require 'spec_helper'

module RestaurantsParser
  describe Parser do
    
    before(:each) do
      @parser = Parser.new deep: 1
    end

    it "should return an array of links with #find_all_links" do
      valid_query = 'http://www.restaurants.com/north-carolina/charlotte/screen/0'
      @parser.send(:find_all_links, valid_query)
      @parser.links.should_not be_empty
    end

    it "should parse porifle with valid link" do
      valid_query = 'http://www.restaurants.com/north-carolina/charlotte/1300-southend-tavern?157951'
      @parser.send(:parse_profile, valid_query)
      @parser.data.first.should_not be_nil
      @parser.data.first[:name].length > 4 unless @parser.data.empty?
    end

    it "should not parse profile with invalid link" do
      invalid_query = 'http://www.restaurants.com/north-carolina/charlotte/a&w-restaurant?25183'
      @parser.send(:parse_profile, invalid_query)
      @parser.data.first.should be_nil
    end
  end
end
