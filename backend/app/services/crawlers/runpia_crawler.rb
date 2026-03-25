module Crawlers
  # Runpia (runpia.co.kr) 크롤러
  # 전국 러닝 대회 및 마라톤 이벤트 정보 집계 사이트
  class RunpiaCrawler < BaseCrawler
    BASE = "https://runpia.co.kr"
    LIST_PATH = "/race/list"

    def fetch_races
      races = []

      # 메인 리스트 + 페이지네이션 (최대 5페이지)
      fetch_paginated("#{BASE}#{LIST_PATH}", page_param: "page", start: 1, max_pages: 5) do |doc, page|
        parsed = parse_race_cards(doc)
        Rails.logger.info "[RunpiaCrawler] 페이지 #{page}: #{parsed.length}건"
        parsed
      end.tap { |r| races.concat(r) }

      races.uniq { |r| r[:source_url] }
    rescue => e
      Rails.logger.error "[RunpiaCrawler] 오류: #{e.message}"
      []
    end

    private

    def parse_race_cards(doc)
      races = []

      # 카드 레이아웃 파싱 (현대 사이트 구조)
      cards = doc.css(".race-card, .event-card, .race-item, article.card, .list-item")
      cards = doc.css(".container .row .col, .race_list li") if cards.empty?
      cards = doc.css("ul.list li, .board_list tbody tr") if cards.empty?

      cards.each do |card|
        race = parse_card(card)
        races << race if race
      rescue => e
        Rails.logger.debug "[RunpiaCrawler] 카드 파싱 오류: #{e.message}"
      end

      races.compact
    end

    def parse_card(card)
      link = card.css("a").first
      return nil unless link

      href = link["href"].to_s
      source_url = if href.start_with?("http")
        href
      elsif href.start_with?("/")
        "#{BASE}#{href}"
      else
        return nil
      end

      # 제목 추출
      title = clean_text(
        card.css(".race-title, .event-title, .title, h2, h3, h4, .subject, .name").first&.text ||
        link.text
      )
      return nil if title.blank? || title.length < 3

      full_text = clean_text(card.text)

      # 날짜 추출
      date_el = card.css(".race-date, .event-date, .date, time, [class*='date'], [class*='time']").first
      date_text = clean_text(date_el&.text || full_text)
      race_date = parse_korean_date(date_text)
      return nil unless race_date
      return nil if race_date < Date.current - 30

      # 장소
      location_el = card.css(".location, .place, .area, .venue, [class*='location'], [class*='place']").first
      location = clean_text(location_el&.text) || extract_location_from_text(full_text)

      # 거리
      distance_el = card.css(".distance, .course, [class*='distance'], [class*='course']").first
      distances = parse_distances(clean_text(distance_el&.text) || full_text)

      # 참가비
      fee_el = card.css(".fee, .price, [class*='fee'], [class*='price']").first
      fee = clean_text(fee_el&.text)

      # 이미지
      img = card.css("img").first
      image_url = img&.[]("src").presence || img&.[]("data-src")
      image_url = "#{BASE}#{image_url}" if image_url&.start_with?("/")

      {
        title: title,
        race_date: race_date,
        location: location || "미정",
        source_url: source_url,
        source_name: "Runpia",
        distances: distances,
        fee_info: fee,
        image_url: image_url,
        raw_data: { text: full_text.truncate(500) }
      }
    end

    def extract_location_from_text(text)
      m = text.match(/(서울|부산|대구|인천|광주|대전|울산|세종|경기|강원|충북|충남|전북|전남|경북|경남|제주)[^\s,\|]{0,20}/)
      m ? m[0].strip : nil
    end
  end
end
