class Organizer::RecordStatisticsController < Organizer::BaseController
  before_action :set_race
  before_action :authorize_race_access!

  def index
    @race_editions = @race.race_editions.includes(:records, :registrations)

    # 전체 통계
    @total_participants = @race.registrations.where(status: 'paid').count
    @total_records = @race.race_editions.joins(:records).count
    @completion_rate = @total_participants > 0 ? (@total_records.to_f / @total_participants * 100).round(1) : 0

    # 종목별 통계
    @edition_stats = @race_editions.map do |edition|
      records = edition.records.order(net_time: :asc)
      participants = edition.registrations.where(status: 'paid').count

      {
        edition: edition,
        participants: participants,
        finishers: records.count,
        completion_rate: participants > 0 ? (records.count.to_f / participants * 100).round(1) : 0,
        avg_time: records.any? ? records.average(:net_time).to_i : 0,
        fastest_time: records.first&.net_time || 0,
        slowest_time: records.last&.net_time || 0
      }
    end

    # 성별 통계
    @gender_stats = calculate_gender_stats

    # 연령대 통계
    @age_group_stats = calculate_age_group_stats

    # 시간대별 완주자 분포 (차트용)
    @time_distribution = calculate_time_distribution

    # 상위 완주자 (user, race_edition preload)
    @top_finishers = Record.joins(:race_edition)
                          .where(race_editions: { race_id: @race.id })
                          .includes(:user, :race_edition)
                          .order(net_time: :asc)
                          .limit(20)
  end

  private

  def set_race
    @race = current_organizer_profile.races.includes(:race_editions).find(params[:race_id])
  end

  def authorize_race_access!
    return if current_user.admin?
    return if @race.organizer.user_id == current_user.id

    redirect_to organizer_root_path, alert: '접근 권한이 없습니다.'
  end

  def calculate_gender_stats
    stats = {}

    %w[male female].each do |gender|
      records = Record.joins(:user, :race_edition)
                     .where(race_editions: { race_id: @race.id })
                     .where(users: { gender: gender })

      stats[gender] = {
        count: records.count,
        avg_time: records.any? ? records.average(:net_time).to_i : 0,
        fastest_time: records.minimum(:net_time) || 0
      }
    end

    stats
  end

  def calculate_age_group_stats
    stats = {}
    age_groups = ['10대', '20대', '30대', '40대', '50대', '60대이상']

    age_groups.each do |age_group|
      records = Record.joins(:user, :race_edition)
                     .where(race_editions: { race_id: @race.id })
                     .where(users: { age_group: age_group })

      stats[age_group] = {
        count: records.count,
        avg_time: records.any? ? records.average(:net_time).to_i : 0,
        fastest_time: records.minimum(:net_time) || 0
      }
    end

    stats
  end

  def calculate_time_distribution
    # 10분 단위로 그룹화
    distribution = {}

    @race.race_editions.each do |edition|
      edition.records.each do |record|
        time_minutes = (record.net_time / 60.0).floor
        bucket = (time_minutes / 10) * 10  # 10분 단위로 반올림

        key = "#{bucket}-#{bucket + 10}분"
        distribution[key] ||= 0
        distribution[key] += 1
      end
    end

    distribution.sort_by { |k, v| k.split('-').first.to_i }.to_h
  end
end
