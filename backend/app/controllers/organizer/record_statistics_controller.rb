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

      # net_time이 String("HH:MM:SS") 형식이므로 초 단위로 변환하여 계산
      time_seconds = records.map { |r| time_to_seconds(r.net_time) }
      avg_seconds = time_seconds.any? ? (time_seconds.sum / time_seconds.size).to_i : 0

      {
        edition: edition,
        participants: participants,
        finishers: records.count,
        completion_rate: participants > 0 ? (records.count.to_f / participants * 100).round(1) : 0,
        avg_time: avg_seconds,
        fastest_time: records.first&.net_time || '-',
        slowest_time: records.last&.net_time || '-'
      }
    end

    # 성별 통계
    @gender_stats = calculate_gender_stats

    # 연령대 통계
    @age_group_stats = calculate_age_group_stats

    # 시간대별 완주자 분포 (차트용, net_time String 변환 적용)
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

  # 시간 문자열("HH:MM:SS" 또는 "MM:SS")을 초 단위로 변환
  def time_to_seconds(time_str)
    return 0 unless time_str.present?
    parts = time_str.to_s.split(':').map(&:to_f)
    case parts.length
    when 3 then parts[0] * 3600 + parts[1] * 60 + parts[2]
    when 2 then parts[0] * 60 + parts[1]
    else parts[0]
    end
  end

  def calculate_gender_stats
    stats = {}

    %w[male female].each do |gender|
      records = Record.joins(:user, :race_edition)
                     .where(race_editions: { race_id: @race.id })
                     .where(users: { gender: gender })

      time_seconds = records.pluck(:net_time).map { |t| time_to_seconds(t) }
      avg_seconds = time_seconds.any? ? (time_seconds.sum / time_seconds.size).to_i : 0

      stats[gender] = {
        count: records.count,
        avg_time: avg_seconds,
        fastest_time: records.order(net_time: :asc).first&.net_time || '-'
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

      time_seconds = records.pluck(:net_time).map { |t| time_to_seconds(t) }
      avg_seconds = time_seconds.any? ? (time_seconds.sum / time_seconds.size).to_i : 0

      stats[age_group] = {
        count: records.count,
        avg_time: avg_seconds,
        fastest_time: records.order(net_time: :asc).first&.net_time || '-'
      }
    end

    stats
  end

  def calculate_time_distribution
    # 10분 단위로 그룹화 (net_time String을 초로 변환 후 분 단위 계산)
    distribution = {}

    @race.race_editions.each do |edition|
      edition.records.each do |record|
        seconds = time_to_seconds(record.net_time)
        time_minutes = (seconds / 60.0).floor
        bucket = (time_minutes / 10) * 10  # 10분 단위로 반올림

        key = "#{bucket}-#{bucket + 10}분"
        distribution[key] ||= 0
        distribution[key] += 1
      end
    end

    distribution.sort_by { |k, _v| k.split('-').first.to_i }.to_h
  end
end
