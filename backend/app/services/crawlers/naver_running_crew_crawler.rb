module Crawlers
  # 네이버 검색 기반 러닝 크루 정보 수집기
  # 네이버 카페 검색 결과에서 러닝 크루 정보를 추출합니다.
  # 수집된 정보는 Crew 모델이 아닌 ExternalRace처럼 별도 처리 (크루 디렉토리 역할)
  class NaverRunningCrewCrawler < BaseCrawler
    # 네이버 오픈API를 통한 카페 검색 (카페 글 검색)
    NAVER_SEARCH_URL = "https://openapi.naver.com/v1/search/cafearticle.json"
    QUERIES = [
      "러닝크루 모집",
      "달리기 크루 멤버 모집",
      "러닝클럽 가입"
    ].freeze

    def fetch_races
      # 이 크롤러는 ExternalRace를 생성하는 대신 CrewDiscovery를 처리
      # 하지만 시스템 통일성을 위해 ExternalRace 형식으로 반환 (type=crew_recruitment)
      fetch_from_naver_search
    rescue => e
      Rails.logger.error "[NaverRunningCrewCrawler] 오류: #{e.message}"
      []
    end

    private

    def fetch_from_naver_search
      client_id = ENV["NAVER_CLIENT_ID"]
      client_secret = ENV["NAVER_CLIENT_SECRET"]

      # API 키 없으면 네이버 카페 직접 크롤링 시도
      return fetch_from_cafe_direct unless client_id.present? && client_secret.present?

      results = []
      QUERIES.each do |query|
        uri = URI.parse("#{NAVER_SEARCH_URL}?query=#{URI.encode_www_form_component(query)}&display=10&sort=date")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri)
        request["X-Naver-Client-Id"] = client_id
        request["X-Naver-Client-Secret"] = client_secret

        response = http.request(request)
        data = JSON.parse(response.body)

        (data["items"] || []).each do |item|
          result = parse_naver_item(item)
          results << result if result
        end
      end

      results.uniq { |r| r[:source_url] }
    end

    def parse_naver_item(item)
      title = ActionView::Base.full_sanitizer.sanitize(item["title"]).strip
      description = ActionView::Base.full_sanitizer.sanitize(item["description"]).strip
      link = item["link"] || item["url"]
      pub_date = item["pubDate"]

      return nil if title.blank? || link.blank?
      return nil unless title.match?(/크루|클럽|달리기|러닝|run/i)

      # 크루 모집 글을 이벤트로 등록
      {
        title: "[크루모집] #{title.truncate(60)}",
        description: description.truncate(300),
        race_date: pub_date ? Date.parse(pub_date) : Date.current,
        location: extract_region(title + " " + description) || "전국",
        source_url: link,
        source_name: "네이버카페-크루",
        distances: [],
        organizer_name: extract_crew_name(title),
        raw_data: { type: "crew_recruitment", original_title: title }
      }
    rescue => e
      nil
    end

    def fetch_from_cafe_direct
      # API 키 없을 때 네이버 카페 직접 접근 (검색봇 차단 가능성 있음)
      []
    end

    def extract_region(text)
      m = text.match(/(서울|부산|대구|인천|광주|대전|울산|세종|수원|성남|용인|고양)[^\s,]{0,10}/)
      m ? m[0] : nil
    end

    def extract_crew_name(text)
      # 대괄호나 따옴표 안의 텍스트
      m = text.match(/[「「『\[\(【]([가-힣a-zA-Z\s]+)[」」』\]\)】]/)
      return m[1].strip if m

      # "~크루" 또는 "~클럽" 패턴
      m = text.match(/([가-힣a-zA-Z]{2,15}(?:크루|클럽|러닝|run))/i)
      m ? m[0] : nil
    end
  end
end
