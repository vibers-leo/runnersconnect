module PosterAnalysis
  module Parsers
    class DistanceParser
      DISTANCE_MAPPINGS = {
        '풀코스' => 42.195,
        '풀' => 42.195,
        'full' => 42.195,
        'marathon' => 42.195,
        '마라톤' => 42.195,

        '하프' => 21.0975,
        'half' => 21.0975,

        '10k' => 10,
        '10km' => 10,
        '10킬로' => 10,

        '5k' => 5,
        '5km' => 5,
        '5킬로' => 5
      }.freeze

      def self.extract_editions(text)
        new(text).extract
      end

      def initialize(text)
        @text = text.downcase
        @lines = text.split("\n")
      end

      def extract
        editions = []
        display_order = 1

        DISTANCE_MAPPINGS.each do |keyword, distance|
          next unless @text.include?(keyword.downcase)

          # 이미 추가된 거리는 스킵
          next if editions.any? { |e| e[:distance] == distance }

          edition = {
            name: normalize_name(keyword),
            distance: distance,
            price: extract_price_for(keyword),
            capacity: extract_capacity_for(keyword),
            age_limit_min: extract_age_limit(keyword),
            age_limit_max: nil,
            display_order: display_order
          }

          editions << edition
          display_order += 1
        end

        # 거리 순으로 정렬 (긴 거리부터)
        editions.sort_by { |e| -e[:distance] }
      end

      private

      def normalize_name(keyword)
        case keyword.downcase
        when /full|풀|marathon|마라톤/ then '풀코스'
        when /half|하프/ then '하프'
        when /10/ then '10K'
        when /5/ then '5K'
        else keyword
        end
      end

      def extract_price_for(keyword)
        # 키워드 근처에서 가격 정보 추출
        # 패턴: "30,000원", "3만원", "30000원"
        pattern = /#{Regexp.escape(keyword)}.{0,100}([\d,]+)\s*[만]?원/i
        match = @text.match(pattern)

        if match
          price_str = match[1].gsub(',', '')
          # "3만원" → 30000
          if @text[match.begin(0)..match.end(0)].include?('만')
            price_str.to_i * 10000
          else
            price_str.to_i
          end
        end
      end

      def extract_capacity_for(keyword)
        # "정원: 5,000명", "선착순 3000명"
        pattern = /#{Regexp.escape(keyword)}.{0,100}(?:정원|선착순|모집)[:\s]*([\d,]+)\s*명/i
        match = @text.match(pattern)
        match ? match[1].gsub(',', '').to_i : nil
      end

      def extract_age_limit(keyword)
        # "만 19세 이상"
        pattern = /#{Regexp.escape(keyword)}.{0,50}만?\s*(\d+)\s*세\s*이상/i
        match = @text.match(pattern)
        match ? match[1].to_i : nil
      end
    end
  end
end
