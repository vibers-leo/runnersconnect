class Api::V1::RaceCalendarController < Api::BaseController
  def index
    year = (params[:year] || Date.current.year).to_i
    month = (params[:month] || Date.current.month).to_i

    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    results = []

    # 플랫폼 내부 대회
    unless params[:source] == "external"
      platform_races = Race.where(status: "open")
                           .where(start_at: start_date.beginning_of_day..end_date.end_of_day)
                           .order(start_at: :asc)
      platform_races = platform_races.where("title ILIKE ?", "%#{params[:q]}%") if params[:q].present?

      platform_races.each do |race|
        results << {
          type: "platform",
          id: race.id,
          title: race.title,
          date: race.start_at.to_date,
          location: race.location,
          registration_open: race.registration_open?,
          distances: race.race_editions.pluck(:name)
        }
      end
    end

    # 외부 대회
    unless params[:source] == "platform"
      external_races = ExternalRace.active.by_month(year, month)
      external_races = external_races.search_by_title(params[:q]) if params[:q].present?

      external_races.each do |race|
        results << {
          type: "external",
          id: race.id,
          title: race.title,
          date: race.race_date,
          location: race.location,
          source_name: race.source_name,
          source_url: race.source_url,
          registration_url: race.registration_url,
          distances: race.distances,
          fee_info: race.fee_info
        }
      end
    end

    render json: {
      races: results.sort_by { |r| r[:date] },
      meta: { year: year, month: month }
    }
  end

  def show
    race = ExternalRace.find(params[:id])
    render json: {
      race: {
        id: race.id,
        title: race.title,
        description: race.description,
        race_date: race.race_date,
        race_end_date: race.race_end_date,
        location: race.location,
        source_url: race.source_url,
        source_name: race.source_name,
        registration_url: race.registration_url,
        registration_deadline: race.registration_deadline,
        distances: race.distances,
        fee_info: race.fee_info,
        organizer_name: race.organizer_name,
        image_url: race.image_url,
        status: race.status
      }
    }
  end
end
