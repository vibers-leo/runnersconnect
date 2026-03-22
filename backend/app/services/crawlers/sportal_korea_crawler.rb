module Crawlers
  # 스포츠포털 / 국민생활체육정보시스템 크롤러
  # 생활체육 마라톤 및 러닝 대회 정보 (지자체 공식 대회 포함)
  class SportalKoreaCrawler < BaseCrawler
    BASE = "https://www.sportal.or.kr"
    # 국민체육진흥공단 생활체육 대회 일정
    SCHEDULE_PATH = "/schedule/list.do"

    def fetch_races
      races = []

      [ Date.current.year, Date.current.year + 1 ].each do |year|
        url = "#{BASE}#{SCHEDULE_PATH}?year=#{year}&sportCode=71" # 71 = 마라톤/달리기
        doc = fetch_page(url)
        parsed = parse_schedule(doc)
        Rails.logger.info "[SportalKoreaCrawler] #{year}년: #{parsed.length}건"
        races.concat(parsed)
      end

      races.uniq { |r| r[:source_url] }
    rescue => e
      Rails.logger.error "[SportalKoreaCrawler] 오류: #{e.message}"
      []
    end

    private

    def parse_schedule(doc)
      races = []

      rows = doc.css("table.tbl_type tbody tr, .schedule_list > li, .event-list .item")
      rows = doc.css("table tbody tr") if rows.empty?

      rows.each do |row|
        race = parse_row(row)
        races << race if race
      rescue => e
        Rails.logger.debug "[SportalKoreaCrawler] 행 오류: #{e.message}"
      end

      races.compact
    end

    def parse_row(row)
      cells = row.css("td")
      full_text = clean_text(row.text)
      return nil if full_text.blank? || full_text.length < 5

      link = row.css("a").first
      href = link&.[]("href").to_s
      source_url = if href.start_with?("http")
        href
      elsif href.present?
        "#{BASE}#{href.start_with?("/") ? "" : "/"}#{href}"
      else
        "#{BASE}/schedule/#{Digest::MD5.hexdigest(full_text)[0..11]}"
      end

      title = clean_text(
        row.css(".title, .subject, td.name").first&.text ||
        link&.text ||
        cells[1]&.text
      )
      return nil if title.blank? || title.length < 3

      race_date = parse_korean_date(full_text)
      return nil unless race_date
      return nil if race_date < Date.current - 30

      location = clean_text(
        row.css(".place, .location, td:nth-child(4)").first&.text
      ) || extract_region(full_text)

      {
        title: title,
        race_date: race_date,
        location: location || "미정",
        source_url: source_url,
        source_name: "스포츠포털",
        distances: parse_distances(full_text),
        organizer_name: extract_organizer(full_text),
        raw_data: { text: full_text }
      }
    end

    def extract_region(text)
      m = text.match(/(서울|부산|대구|인천|광주|대전|울산|세종|경기|강원|충[북남]|전[북남]|경[북남]|제주)[가-힣\s]{0,15}/)
      m ? m[0].strip : nil
    end

    def extract_organizer(text)
      m = text.match(/([가-힣]+(?:시|군|구|도)\s*)?[가-힣]+(?:체육회|마라톤|조직위|육상)/)
      m ? m[0] : nil
    end
  end
end
