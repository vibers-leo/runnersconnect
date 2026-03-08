class CrawlAllSourcesJob < ApplicationJob
  queue_as :crawlers

  def perform
    CrawlSource.due_for_crawl.find_each do |source|
      CrawlSourceJob.perform_later(source.id)
    end
  end
end
