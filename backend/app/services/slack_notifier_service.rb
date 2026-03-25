class SlackNotifierService
  WEBHOOK_URL = ENV['SLACK_WEBHOOK_URL']

  def self.notify(message)
    return unless WEBHOOK_URL.present?

    begin
      uri = URI.parse(WEBHOOK_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
      request.body = { text: message }.to_json

      http.request(request)
    rescue => e
      Rails.logger.error "[SlackNotifier] 알림 전송 실패: #{e.message}"
    end
  end

  def self.notify_crawling_result(results)
    total = results.except(:errors, :duration).values.sum { |v| v.is_a?(Integer) ? v : 0 }

    message = <<~MSG
      🏃 *러너스커넥트 크롤링 완료!*

      📊 *수집 통계:*
      #{results.except(:errors, :duration).map { |k, v| "- #{k}: #{v}개" }.join("\n")}

      ✨ *총 #{total}개 대회 업데이트*
      ⏱ *소요:* #{results[:duration]}초
      #{results[:errors]&.any? ? "⚠️ *에러:* #{results[:errors].size}건" : "✅ *완료*"}
    MSG

    notify(message)
  end

  def self.notify_failure(job_name, error)
    message = <<~MSG
      🚨 *[러너스커넥트] #{job_name} 실패*

      ❌ *에러:* #{error.class}: #{error.message}
      📍 *위치:* #{error.backtrace&.first}
      ⏱ *시간:* #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}
    MSG

    notify(message)
  end
end
