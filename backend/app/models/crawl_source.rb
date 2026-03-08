class CrawlSource < ApplicationRecord
  validates :name, presence: true
  validates :crawler_class, presence: true
  validates :base_url, presence: true

  scope :enabled, -> { where(enabled: true) }
  scope :due_for_crawl, -> {
    enabled.where(
      "last_crawled_at IS NULL OR last_crawled_at < NOW() - make_interval(hours => crawl_interval_hours)"
    )
  }

  def crawler
    crawler_class.constantize.new(self)
  end

  def mark_success!
    update!(last_crawled_at: Time.current, last_error: nil)
  end

  def mark_error!(message)
    update!(last_error: message)
  end
end
