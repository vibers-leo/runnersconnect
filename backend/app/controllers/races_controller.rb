class RacesController < ApplicationController
  # GET /races
  def index
    @races = Race.open.upcoming
    
    if params[:query].present?
      @races = @races.where("title LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    end

    if params[:location].present? && params[:location] != '전체 지역'
      @races = @races.where("location LIKE ?", "%#{params[:location]}%")
    end
  end

  # GET /races/:id
  def show
    @race = Race.find(params[:id])
    @editions = @race.race_editions.order(display_order: :asc)
  end
end
