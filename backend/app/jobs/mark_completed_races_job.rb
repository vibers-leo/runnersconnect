class MarkCompletedRacesJob < ApplicationJob
  queue_as :default

  def perform
    ExternalRace.active.where("race_date < ?", Date.current).update_all(status: :completed)
  end
end
