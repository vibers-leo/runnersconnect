module Api
  module V1
    class RacesController < Api::BaseController
      # GET /api/v1/races
      def index
        @races = Race.where(status: 'open').includes(:race_editions, :organizer).order(start_at: :asc)

        render json: RaceSerializer.new(@races, include: [:race_editions]).serializable_hash
      end

      # GET /api/v1/races/:id
      def show
        @race = Race.includes(:race_editions, :organizer).find(params[:id])

        render json: RaceSerializer.new(@race, include: [:race_editions]).serializable_hash
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Race not found' }, status: :not_found
      end
    end
  end
end
