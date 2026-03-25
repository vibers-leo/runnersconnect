class CrawlLog < ApplicationRecord
  validates :job_name, presence: true
  validates :started_at, presence: true
  validates :status, presence: true, inclusion: { in: %w[running completed failed] }

  scope :recent, -> { order(started_at: :desc) }
  scope :completed, -> { where(status: 'completed') }
  scope :failed, -> { where(status: 'failed') }
  scope :running, -> { where(status: 'running') }
  scope :by_job, ->(job_name) { where(job_name: job_name) }

  def self.record_execution(job_name)
    log = create(
      job_name: job_name,
      started_at: Time.current,
      status: 'running'
    )

    begin
      result = yield(log)

      log.update(
        status: 'completed',
        completed_at: Time.current,
        duration_seconds: (Time.current - log.started_at).round(2),
        results: result.is_a?(Hash) ? result : { count: result.to_i },
        event_count: result.is_a?(Hash) ? result.except(:errors, :duration).values.sum { |v| v.is_a?(Integer) ? v : 0 } : result.to_i,
        error_count: result.is_a?(Hash) ? (result[:errors]&.size || 0) : 0,
        error_details: result.is_a?(Hash) ? result[:errors]&.join("\n") : nil
      )

      result
    rescue => e
      log.update(
        status: 'failed',
        completed_at: Time.current,
        duration_seconds: (Time.current - log.started_at).round(2),
        error_count: 1,
        error_details: "#{e.class}: #{e.message}\n#{e.backtrace.first(5).join("\n")}"
      )

      SlackNotifierService.notify_failure(job_name, e)
      raise e
    end
  end

  def duration_in_minutes
    return nil unless duration_seconds
    (duration_seconds / 60).round(2)
  end

  def success?
    status == 'completed' && (error_count.nil? || error_count.zero?)
  end
end
