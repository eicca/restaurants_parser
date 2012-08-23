module RestaurantsParser
  class Parser

    attr_reader :data
    attr_reader :links

    def initialize(options = {})
      default_options = {
        deep: 3,
        debug: false,
        user_agent: 'Mac Safari',
        sleep_secs: 1
      }
      options = default_options.merge options

      @agent = Mechanize.new do |a|
        a.user_agent_alias = options[:user_agent]
      end

      @debug = options[:debug]
      @deep = options[:deep]
      @sleep_secs = options[:sleep_secs]

      @links = []
      @data = []
    end

    def parse(query)
      if query[-1] != ?/
        query += ?/
      end
      find_all_links query
      @links.each do |link|
        parse_profile link 
        sleep @sleep_secs
      end
      self
    end

    private

    def find_all_links(query)
      index = 0
      loop do
        page = @agent.get(query + "screen/#{index * 10}")
        results = page.search('.listing_summary_header>h3>a')
        if (index == @deep and @deep != 0) or results.empty?
          break
        else
          results.each { |link| @links << link['href'] }
          index += 1
        end
      end
    end

    def parse_profile(link)
      p link if @debug

      begin
        el = {}

        page = @agent.get(link)
        el[:url] = link
        el[:name] = page.get_content '#lstTitle'
        el[:address1] = page.get_content '#lstAddress1'
        address2 = page.get_content '#lstAddress2'
        el[:address2] = address2 unless address2.empty?
        el[:global_address] = page.get_content '#lstNeighborhoodspspan'
        el[:phone] = page.get_content '#lstPhone'
        el[:website] = page.get_content '#lstUrl'
        image = page.get_content '#lstLogo'
        el[:image] = image unless image.include?('noPhoto')
        @data << el
      rescue Mechanize::ResponseCodeError
        p "#{link} - not found" if @debug
      end
    end

    end
end

class Mechanize::Page < Mechanize::File
  def get_content(path)
    if el = self.search(path).first
      el.content.strip
    end
  end
end
