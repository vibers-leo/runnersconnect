class RecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @records = current_user.records.includes(:race_edition).order(created_at: :desc)
    
    # Calculate personal bests
    @pb_5k = current_user.records.where("race_editions.distance = ?", 5).joins(:race_edition).minimum(:net_time)
    @pb_10k = current_user.records.where("race_editions.distance = ?", 10).joins(:race_edition).minimum(:net_time)
    @pb_half = current_user.records.where("race_editions.distance = ?", 21.0975).joins(:race_edition).minimum(:net_time)
    @pb_full = current_user.records.where("race_editions.distance = ?", 42.195).joins(:race_edition).minimum(:net_time)
    
    @total_distance = current_user.records.joins(:race_edition).sum("race_editions.distance")
    @total_races = current_user.records.count
  end

  def show
    @record = current_user.records.includes(race_edition: :race).find(params[:id])
  end
end
