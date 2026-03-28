class Organizer::RacesController < Organizer::BaseController
  before_action :set_race, only: [:show]

  def index
    @races = current_organizer_profile.races.order(start_at: :desc)
  end

  def show
    @race_editions = @race.race_editions.includes(:registrations)
    @total_participants = @race.registrations.where(status: 'paid').count
  end

  private

  def set_race
    @race = current_organizer_profile.races.find(params[:id])
  end
end
