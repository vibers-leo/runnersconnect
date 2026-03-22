module Crawlers
  class BaseCrawler
    BROWSER_USER_AGENTS = [
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    ].freeze

    def initialize(crawl_source)
      @source = crawl_source
    end

    def fetch_races
      raise NotImplementedError, "#{self.class}#fetch_races를 구현해주세요"
    end

    private

    # HTML 페이지 가져오기 (EUC-KR 자동 감지 및 변환 포함)
    def fetch_page(url, max_retries: 2)
      uri = URI.parse(url)
      retries = 0

      begin
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == "https")
        http.open_timeout = 15
        http.read_timeout = 30

        request = Net::HTTP::Get.new(uri)
        request["User-Agent"] = BROWSER_USER_AGENTS.sample
        request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
        request["Accept-Language"] = "ko-KR,ko;q=0.9,en;q=0.8"
        request["Accept-Encoding"] = "identity"

        response = http.request(request)

        # 리다이렉트 처리 (최대 3번)
        redirect_count = 0
        while response.is_a?(Net::HTTPRedirection) && redirect_count < 3
          location = response["location"]
          redirect_uri = URI.parse(location)
          redirect_uri = URI.parse("#{uri.scheme}://#{uri.host}#{location}") if redirect_uri.relative?
          uri = redirect_uri
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = (uri.scheme == "https")
          request = Net::HTTP::Get.new(uri)
          request["User-Agent"] = BROWSER_USER_AGENTS.sample
          response = http.request(request)
          redirect_count += 1
        end

        parse_html(response.body)
      rescue Net::ReadTimeout, Net::OpenTimeout, Errno::ECONNREFUSED, SocketError => e
        retries += 1
        if retries <= max_retries
          sleep(2 ** retries)
          retry
        end
        Rails.logger.error "[#{self.class.name}] 네트워크 오류 (#{url}): #{e.message}"
        Nokogiri::HTML("")
      rescue => e
        Rails.logger.error "[#{self.class.name}] 페이지 로드 실패 (#{url}): #{e.message}"
        Nokogiri::HTML("")
      end
    end

    # HTML 파싱 (EUC-KR <-> UTF-8 자동 감지)
    def parse_html(body)
      # 인코딩 감지: meta charset 확인
      raw = body.dup.force_encoding("ASCII-8BIT")
      charset = raw.match(/charset[=:]["']?\s*([\w-]+)/i)&.captures&.first&.downcase

      if charset&.include?("euc-kr") || charset&.include?("ks_c_5601")
        body = raw.encode("UTF-8", "EUC-KR", invalid: :replace, undef: :replace)
      else
        body = body.force_encoding("UTF-8").scrub("?")
      end

      Nokogiri::HTML(body)
    end

    # 텍스트 정제
    def clean_text(text)
      return nil if text.nil?
      text.gsub(/\u00a0|\u3000/, " ").gsub(/\s+/, " ").strip
    end

    # 한국어 날짜 파싱 (다양한 포맷 지원)
    def parse_korean_date(text)
      return nil if text.blank?
      text = clean_text(text)

      # 여러 날짜 포맷 시도
      formats = [
        /(\d{4})[년.\-\/](\d{1,2})[월.\-\/](\d{1,2})/,   # 2026년3월15일, 2026.3.15, 2026-3-15
        /(\d{2})[.\-\/](\d{1,2})[.\-\/](\d{1,2})/,         # 26.3.15
        /(\d{4})(\d{2})(\d{2})/                              # 20260315
      ]

      formats.each do |fmt|
        m = text.match(fmt)
        next unless m

        year  = m[1].length == 2 ? "20#{m[1]}" : m[1]
        month = m[2].to_i
        day   = m[3].to_i

        next unless month.between?(1, 12) && day.between?(1, 31)
        return Date.new(year.to_i, month, day)
      rescue ArgumentError
        next
      end

      nil
    end

    # 거리 정보 파싱
    def parse_distances(text)
      return [] if text.blank?
      distances = []
      distances << "풀코스" if text.match?(/풀코스|42\.?195?|42km|마라톤/i)
      distances << "하프코스" if text.match?(/하프|21\.?0975?|21km/i)
      distances << "10km" if text.match?(/10k|10\s*km/i)
      distances << "5km" if text.match?(/5k|5\s*km/i)
      distances << "울트라" if text.match?(/울트라|50km|100km/i)
      distances << text.strip if distances.empty? && text.match?(/\d+\s*km/i)
      distances.uniq
    end

    # 여러 페이지 크롤링 헬퍼
    def fetch_paginated(base_url, page_param: "page", start: 1, max_pages: 5)
      results = []
      start.upto(max_pages) do |page|
        url = "#{base_url}#{base_url.include?("?") ? "&" : "?"}#{page_param}=#{page}"
        doc = fetch_page(url)
        items = yield(doc, page)
        results.concat(items)
        break if items.empty?
      end
      results
    end
  end
end
