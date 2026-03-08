class CrawlSourceJob < ApplicationJob
  queue_as :crawlers
  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform(crawl_source_id)
    source = CrawlSource.find(crawl_source_id)
    crawler = source.crawler
    races_data = crawler.fetch_races

    races_data.each do |data|
      race = ExternalRace.find_or_initialize_by(source_url: data[:source_url])
      new_hash = Digest::SHA256.hexdigest(data.except(:raw_data).to_json)

      next if race.persisted? && race.content_hash == new_hash

      race.assign_attributes(data.merge(
        source_name: source.name,
        crawled_at: Time.current,
        content_hash: new_hash
      ))
      race.save!
    end

    source.mark_success!
  rescue => e
    source&.mark_error!(e.message)
    raise
  end
end
