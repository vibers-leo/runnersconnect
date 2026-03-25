class RaceCalendarController < ApplicationController
  def index
    @year = (params[:year] || Date.current.year).to_i
    @month = (params[:month] || Date.current.month).to_i

    # 외부 대회
    @external_races = ExternalRace.active
                                   .by_month(@year, @month)
                                   .search_by_title(params[:q])
                                   .order(race_date: :asc)

    # 플랫폼 내부 대회
    start_date = Date.new(@year, @month, 1)
    end_date = start_date.end_of_month
    @platform_races = Race.where(status: "open")
                          .where(start_at: start_date.beginning_of_day..end_date.end_of_day)
                          .order(start_at: :asc)

    if params[:q].present?
      @platform_races = @platform_races.where("title ILIKE ?", "%#{params[:q]}%")
    end

    # 통합 목록 (날짜순)
    @combined_races = build_combined_list(@platform_races, @external_races)

    # 달력 네비게이션
    @prev_date = Date.new(@year, @month, 1) - 1.month
    @next_date = Date.new(@year, @month, 1) + 1.month
  end

  def show
    @race = ExternalRace.find(params[:id])
  end

  private

  def build_combined_list(platform_races, external_races)
    combined = []

    platform_races.each do |race|
      combined << {
        type: "platform",
        title: race.title,
        date: race.start_at.to_date,
        location: race.location,
        path: race_path(race),
        race: race
      }
    end

    external_races.each do |race|
      combined << {
        type: "external",
        title: race.title,
        date: race.race_date,
        location: race.location,
        path: race_calendar_show_path(race),
        race: race
      }
    end

    combined.sort_by { |r| r[:date] }
  end
end
