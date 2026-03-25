module PosterAnalysis
  module Parsers
    class RaceInfoParser
      def initialize(text)
        @text = text
        @lines = text.split("\n").map(&:strip).reject(&:empty?)
      end

      def parse
        {
          race: {
            title: extract_title,
            location: extract_location,
            start_at: DateParser.parse(@text, context: :event_date),
            registration_start_at: DateParser.parse(@text, context: :registration_start),
            registration_end_at: DateParser.parse(@text, context: :registration_end),
            refund_deadline: DateParser.parse(@text, context: :refund_deadline),
            organizer_name: ContactParser.extract_organizer(@text),
            official_site_url: ContactParser.extract_url(@text),
            is_official_record: detect_official_record
          },
          race_editions: DistanceParser.extract_editions(@text)
        }
      end

      private

      def extract_title
        # 대회명은 보통 큰 글씨로 상단에 위치
        # 패턴: "XXXX 마라톤", "제N회 XXXX", "YYYY년 XXXX"
        patterns = [
          /([^\n]{5,50}(?:마라톤|달리기|러닝|run|running))/i,
          /(제\s*\d+\s*회\s*[^\n]{3,30})/,
          /(\d{4}\s*년?\s*[^\n]{3,30}(?:대회|마라톤))/
        ]

        patterns.each do |pattern|
          match = @text.match(pattern)
          return match[1].strip if match
        end

        # Fallback: 첫 번째 줄 (보통 제목)
        @lines.first
      end

      def extract_location
        # "장소:", "개최지:", "START" 등 키워드 탐색
        location_keywords = ['장소', '개최지', 'START', 'LOCATION']

        location_keywords.each do |keyword|
          pattern = /#{Regexp.escape(keyword)}\s*[:：]?\s*([^\n]{3,50})/i
          match = @text.match(pattern)
          return match[1].strip if match
        end

        # 지명 패턴 매칭 (서울, 부산 등)
        cities = %w[서울 부산 대구 인천 광주 대전 울산 세종 춘천 강릉 청주 전주 포항 창원 제주]
        cities.each do |city|
          if @text.include?(city)
            # 주변 문맥 추출
            context = extract_context_around(city, window: 20)
            return context if context
          end
        end

        nil
      end

      def detect_official_record
        keywords = ['공인기록', '공인 기록', '공식기록', '공식 기록', 'OFFICIAL RECORD']
        keywords.any? { |kw| @text.include?(kw) }
      end

      def extract_context_around(keyword, window: 20)
        index = @text.index(keyword)
        return nil unless index

        start_pos = [index - window, 0].max
        end_pos = [index + keyword.length + window, @text.length].min
        @text[start_pos...end_pos].strip
      end
    end
  end
end
