module Crawlers
  class BaseCrawler
    def initialize(crawl_source)
      @source = crawl_source
    end

    def fetch_races
      raise NotImplementedError, "#{self.class}#fetch_races를 구현해주세요"
    end

    private

    def fetch_page(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.open_timeout = 15
      http.read_timeout = 30

      request = Net::HTTP::Get.new(uri)
      request["User-Agent"] = "RunnersConnect Bot/1.0 (+https://runnersconnect.com)"

      response = http.request(request)
      Nokogiri::HTML(response.body.force_encoding("UTF-8"))
    end
  end
end
