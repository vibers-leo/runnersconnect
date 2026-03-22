module Crawlers
  # 마라톤온라인 (marathon.pe.kr) 크롤러
  # 한국에서 가장 오래된 마라톤 정보 커뮤니티. 대회 캘린더 제공.
  class MarathonPeKrCrawler < BaseCrawler
    BASE = "http://marathon.pe.kr"
    CALENDAR_PATH = "/sub03/schedule01.php"

    def fetch_races
      races = []

      # 올해와 내년 대회 모두 수집
      [ Date.current.year, Date.current.year + 1 ].each do |year|
        url = "#{BASE}#{CALENDAR_PATH}?year=#{year}"
        doc = fetch_page(url)
        races.concat(parse_race_list(doc))
      end

      races.uniq { |r| r[:source_url] }
    rescue => e
      Rails.logger.error "[MarathonPeKrCrawler] 오류: #{e.message}"
      []
    end

    private

    def parse_race_list(doc)
      races = []

      # 테이블 구조 파싱 (그누보드 기반 리스트)
      rows = doc.css("table.board_list tbody tr, table#list tbody tr, .tbl_list tbody tr")
      rows = doc.css("table tr") if rows.empty?

      rows.each do |row|
        cells = row.css("td")
        next if cells.length < 3

        race = extract_from_cells(cells, row)
        races << race if race
      rescue => e
        Rails.logger.debug "[MarathonPeKrCrawler] 행 파싱 오류: #{e.message}"
      end

      # 테이블 구조가 아닌 경우 — 리스트형 파싱 시도
      if races.empty?
        doc.css(".schedule_list li, .race_list li, .list_wrap li").each do |item|
          race = extract_from_list_item(item)
          races << race if race
        end
      end

      races.compact
    end

    def extract_from_cells(cells, row)
      texts = cells.map { |c| clean_text(c.text) }
      return nil if texts.all?(&:blank?)

      # 링크에서 URL 추출
      link = row.css("a").first
      return nil unless link

      href = link["href"].to_s
      source_url = href.start_with?("http") ? href : "#{BASE}#{href.start_with?("/") ? "" : "/"}#{href}"
      return nil if source_url.blank?

      title = clean_text(link.text)
      return nil if title.blank? || title.length < 3

      # 날짜 파싱 — 두 번째 또는 세 번째 셀에서 탐색
      race_date = nil
      texts[1..4].each do |t|
        race_date = parse_korean_date(t)
        break if race_date
      end
      return nil unless race_date
      return nil if race_date < Date.current - 30

      # 지역/장소
      location = texts[2..4].find { |t| t.present? && !t.match?(/^\d/) } || "미정"

      # 거리
      distance_text = texts.join(" ")
      distances = parse_distances(distance_text)

      # 참가비
      fee = texts.find { |t| t&.match?(/원|fee|참가비/i) }

      {
        title: title,
        race_date: race_date,
        location: location,
        source_url: source_url,
        source_name: "마라톤온라인",
        distances: distances,
        fee_info: fee,
        raw_data: { cells: texts }
      }
    end

    def extract_from_list_item(item)
      link = item.css("a").first
      return nil unless link

      href = link["href"].to_s
      source_url = href.start_with?("http") ? href : "#{BASE}#{href}"
      title = clean_text(link.text)
      return nil if title.blank?

      text = clean_text(item.text)
      race_date = parse_korean_date(text)
      return nil unless race_date

      {
        title: title,
        race_date: race_date,
        location: clean_text(item.css(".location, .place, .area").first&.text) || "미정",
        source_url: source_url,
        source_name: "마라톤온라인",
        distances: parse_distances(text),
        raw_data: { text: text }
      }
    end
  end
end
