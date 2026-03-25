module PosterAnalysis
  module Parsers
    class DateParser
      PATTERNS = {
        # "2026년 3월 15일", "2026.3.15", "2026-03-15"
        full_date: /(\d{4})[\s년\.\/\-]+(\d{1,2})[\s월\.\/\-]+(\d{1,2})/,

        # "3월 15일(일)", "3/15(일)"
        month_day: /(\d{1,2})[\s월\.\/]+(\d{1,2})[\s일]?[\(（]?[월화수목금토일]?[\)）]?/,

        # "접수: 1/10 - 3/10", "등록 기간: 2월 1일 ~ 3월 10일"
        date_range: /(\d{1,2})[월\.\/](\d{1,2})[\s일]?\s*[-~～]\s*(\d{1,2})[월\.\/](\d{1,2})/,

        # "오전 9시", "09:00", "9:00 AM"
        time: /(?:오전|오후|AM|PM)?\s*(\d{1,2})[\s시:](\d{2})?/
      }.freeze

      CONTEXT_KEYWORDS = {
        event_date: ['대회', '개최', 'START', '출발'],
        registration_start: ['접수 시작', '등록 시작', '신청 시작'],
        registration_end: ['접수 마감', '등록 마감', '신청 마감'],
        refund_deadline: ['환불 마감', '취소 마감']
      }.freeze

      def self.parse(text, context: nil)
        new(text, context).parse
      end

      def initialize(text, context = nil)
        @text = text
        @context = context
      end

      def parse
        # 컨텍스트 기반 날짜 추출
        date_string = if @context
          extract_by_context(@context)
        else
          extract_any_date
        end

        return nil unless date_string

        # 날짜 문자열 → DateTime 변환
        parse_date_string(date_string)
      end

      private

      def extract_by_context(context)
        keywords = CONTEXT_KEYWORDS[context] || []

        keywords.each do |keyword|
          # 키워드 주변 탐색
          pattern = /#{Regexp.escape(keyword)}\s*[:：]?\s*(.{0,50})/
          match = @text.match(pattern)

          if match
            # 추출된 텍스트에서 날짜 패턴 찾기
            date_match = match[1].match(PATTERNS[:full_date]) ||
                         match[1].match(PATTERNS[:month_day])
            return date_match[0] if date_match
          end
        end

        nil
      end

      def extract_any_date
        # 전체 텍스트에서 첫 번째 날짜 패턴 추출
        PATTERNS.each do |_type, pattern|
          match = @text.match(pattern)
          return match[0] if match
        end
        nil
      end

      def parse_date_string(date_str)
        # "2026년 3월 15일" → DateTime
        if (match = date_str.match(PATTERNS[:full_date]))
          year, month, day = match[1].to_i, match[2].to_i, match[3].to_i
          Time.zone.parse("#{year}-#{month}-#{day}")
        # "3월 15일" → 연도 추론
        elsif (match = date_str.match(PATTERNS[:month_day]))
          month, day = match[1].to_i, match[2].to_i
          infer_year_and_parse(month, day)
        end
      end

      def infer_year_and_parse(month, day)
        # 현재 연도 기준으로 추론
        current_year = Time.current.year
        date = Time.zone.parse("#{current_year}-#{month}-#{day}")

        # 과거 날짜라면 다음 해로 추정
        date = Time.zone.parse("#{current_year + 1}-#{month}-#{day}") if date < Time.current

        date
      end
    end
  end
end
