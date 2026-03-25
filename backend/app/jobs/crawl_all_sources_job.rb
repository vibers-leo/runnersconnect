class CrawlAllSourcesJob < ApplicationJob
  queue_as :crawlers

  def perform
    CrawlLog.record_execution("CrawlAllSourcesJob") do |log|
      sources = CrawlSource.due_for_crawl.to_a

      sources.each do |source|
        CrawlSourceJob.perform_later(source.id)
      end

      { enqueued: sources.size }
    end
  end
end
