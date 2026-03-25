module PosterAnalysis
  module Parsers
    class PriceParser
      def self.parse(text)
        # "30,000원", "3만원", "$30"
        patterns = [
          /([\d,]+)\s*원/,
          /(\d+)\s*만\s*원/,
          /\$\s*([\d,]+)/
        ]

        patterns.each do |pattern|
          match = text.match(pattern)
          return parse_price_match(match, text) if match
        end

        nil
      end

      def self.parse_price_match(match, text)
        if text.include?('만')
          match[1].to_i * 10000
        else
          match[1].gsub(',', '').to_i
        end
      end
    end
  end
end
