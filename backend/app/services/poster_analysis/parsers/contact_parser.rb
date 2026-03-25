module PosterAnalysis
  module Parsers
    class ContactParser
      def self.extract_organizer(text)
        # "주최: 서울시체육회", "주관: ..."
        patterns = [
          /주최\s*[:：]\s*([^\n]{3,30})/,
          /주관\s*[:：]\s*([^\n]{3,30})/,
          /주최기관\s*[:：]\s*([^\n]{3,30})/
        ]

        patterns.each do |pattern|
          match = text.match(pattern)
          return match[1].strip if match
        end

        nil
      end

      def self.extract_url(text)
        # URL 패턴
        pattern = /(https?:\/\/[^\s\)]+)/
        match = text.match(pattern)
        match ? match[1] : nil
      end
    end
  end
end
