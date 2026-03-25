class Organizer::DashboardController < Organizer::BaseController
  def index
    @races = current_organizer_profile.races.order(start_at: :desc)
    @upcoming_races = @races.where('start_at > ?', Time.current)
                            .includes(:registrations)
                            .limit(5)
    @total_participants = current_organizer_profile.total_participants_count
    @recent_registrations = Registration.joins(:race)
                                       .where(races: { organizer_id: current_organizer_profile.id })
                                       .includes(:user, :race, :race_edition)
                                       .order(created_at: :desc)
                                       .limit(10)
  end
end
