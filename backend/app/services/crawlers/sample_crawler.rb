module Crawlers
  # 샘플 크롤러 - 실제 사이트 연동 시 이 패턴을 참고하여 구현
  class SampleCrawler < BaseCrawler
    def fetch_races
      # 실제 구현 시 fetch_page(@source.base_url)로 HTML을 가져와
      # Nokogiri로 파싱하여 대회 정보를 추출합니다.
      #
      # 반환 형식:
      # [
      #   {
      #     title: "2026 서울 마라톤",
      #     description: "서울에서 열리는 대규모 마라톤",
      #     race_date: Date.new(2026, 4, 15),
      #     location: "서울 여의도공원",
      #     source_url: "https://example.com/races/1",
      #     registration_url: "https://example.com/races/1/register",
      #     distances: ["풀코스", "하프", "10km"],
      #     fee_info: "풀코스 50,000원 / 하프 40,000원",
      #     organizer_name: "서울시체육회",
      #     raw_data: { ... }
      #   }
      # ]
      []
    end
  end
end
