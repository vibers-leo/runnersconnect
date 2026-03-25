class CrawlSourceJob < ApplicationJob
  queue_as :crawlers
  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform(crawl_source_id)
    source = CrawlSource.find(crawl_source_id)

    CrawlLog.record_execution("CrawlSourceJob:#{source.name}") do |log|
      crawler = source.crawler
      races_data = crawler.fetch_races

      created_count = 0
      updated_count = 0
      skipped_count = 0
      errors = []

      races_data.each do |data|
        race = ExternalRace.find_or_initialize_by(source_url: data[:source_url])
        new_hash = Digest::SHA256.hexdigest(data.except(:raw_data).to_json)

        if race.persisted? && race.content_hash == new_hash
          skipped_count += 1
          next
        end

        was_new = race.new_record?
        race.assign_attributes(data.merge(
          source_name: source.name,
          crawled_at: Time.current,
          content_hash: new_hash
        ))
        race.save!

        was_new ? created_count += 1 : updated_count += 1
      rescue => e
        errors << "[#{data[:source_url]}] #{e.message}"
        Rails.logger.error "[CrawlSourceJob] 저장 실패 (#{data[:source_url]}): #{e.message}"
      end

      source.mark_success!

      Rails.logger.info "[CrawlSourceJob] #{source.name} 완료 — 신규: #{created_count}, 갱신: #{updated_count}, 변동없음: #{skipped_count}"

      { created: created_count, updated: updated_count, skipped: skipped_count, errors: errors }
    end
  rescue => e
    source&.mark_error!(e.message)
    raise
  end
end
