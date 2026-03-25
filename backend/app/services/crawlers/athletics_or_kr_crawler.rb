module Crawlers
  # 대한육상연맹 (korea-athletics.org) 크롤러
  # 공인 대회 일정 및 공식 기록 대회 정보 제공
  class AthleticsOrKrCrawler < BaseCrawler
    BASE = "https://www.athletics.or.kr"
    SCHEDULE_PATH = "/program/schedule/schedule_list.asp"

    def fetch_races
      races = []

      [ Date.current.year, Date.current.year + 1 ].each do |year|
        url = "#{BASE}#{SCHEDULE_PATH}?year=#{year}&type=all"
        doc = fetch_page(url)
        races.concat(parse_schedule(doc, year))
      end

      races.uniq { |r| r[:source_url] }
    rescue => e
      Rails.logger.error "[AthleticsOrKrCrawler] 오류: #{e.message}"
      []
    end

    private

    def parse_schedule(doc, year)
      races = []

      # 주요 선택자 시도
      rows = doc.css("table.list tbody tr, .schedule_list li, table tbody tr")

      rows.each do |row|
        race = parse_row(row, year)
        races << race if race
      rescue => e
        Rails.logger.debug "[AthleticsOrKrCrawler] 행 파싱 오류: #{e.message}"
      end

      races.compact
    end

    def parse_row(row, year)
      cells = row.css("td, li")
      full_text = clean_text(row.text)
      return nil if full_text.blank? || full_text.length < 5

      link = row.css("a").first
      href = link&.[]("href").to_s
      source_url = if href.start_with?("http")
        href
      elsif href.present?
        "#{BASE}#{href.start_with?("/") ? "" : "/"}#{href}"
      else
        # 링크 없으면 고유 URL 생성 (제목+날짜 해시)
        "#{BASE}/schedule/#{Digest::MD5.hexdigest(full_text)[0..7]}"
      end

      title = clean_text(link&.text || cells.first&.text)
      return nil if title.blank? || title.length < 3

      race_date = parse_korean_date(full_text)
      return nil unless race_date
      return nil if race_date < Date.current - 30

      location = extract_location(cells, full_text)
      distances = parse_distances(full_text)
      distances = [ "풀코스", "하프코스" ] if distances.empty? # 육상연맹은 보통 공인 마라톤

      {
        title: title,
        race_date: race_date,
        location: location,
        source_url: source_url,
        source_name: "대한육상연맹",
        distances: distances,
        organizer_name: extract_organizer(full_text),
        is_official_record: true,
        raw_data: { text: full_text, year: year }
      }
    end

    def extract_location(cells, full_text)
      # 셀에서 지역명 패턴 탐색
      korean_regions = /서울|부산|대구|인천|광주|대전|울산|세종|경기|강원|충북|충남|전북|전남|경북|경남|제주/
      location_cell = cells.find { |c| clean_text(c.text)&.match?(korean_regions) }
      return clean_text(location_cell.text) if location_cell

      # 텍스트에서 지역명 추출
      m = full_text.match(/#{korean_regions}[시도군구\s]?[가-힣\s]+/)
      m ? m[0].strip : "미정"
    end

    def extract_organizer(text)
      m = text.match(/(대한|한국|서울|부산|[가-힣]+)[가-힣]+(?:연맹|협회|조직위|육상|체육)/i)
      m ? m[0] : nil
    end
  end
end
