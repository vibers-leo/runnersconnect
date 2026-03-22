class UpdateCrewStatsJob < ApplicationJob
  queue_as :default

  def perform
    updated = 0

    Crew.published.find_each do |crew|
      # 참가 기록 기반 실제 멤버 수 계산
      actual_member_count = crew.registrations
                                .joins(:race_edition)
                                .where(status: "paid")
                                .select(:user_id)
                                .distinct
                                .count

      # 최근 6개월 활동 대회 수
      recent_race_count = crew.registrations
                              .joins(race_edition: :race)
                              .where(races: { start_at: 6.months.ago.. })
                              .where(registrations: { status: "paid" })
                              .select("races.id")
                              .distinct
                              .count

      updates = {}
      # 등록된 멤버가 있으면 실제 수로 업데이트
      updates[:member_count_estimate] = [ actual_member_count, crew.member_count_estimate.to_i ].max if actual_member_count > 0

      crew.update_columns(updates) if updates.present?
      updated += 1
    rescue => e
      Rails.logger.error "[UpdateCrewStatsJob] 크루 ##{crew.id} 업데이트 실패: #{e.message}"
    end

    Rails.logger.info "[UpdateCrewStatsJob] #{updated}개 크루 통계 업데이트 완료"
  end
end
