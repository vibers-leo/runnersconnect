class Admin::ExternalRacesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_race, only: [:edit, :update, :destroy]

  def index
    @external_races = ExternalRace.order(race_date: :desc)
    @external_races = @external_races.from_source(params[:source]) if params[:source].present?
  end

  def edit
  end

  def update
    if @race.update(race_params)
      redirect_to admin_external_races_path, notice: "대회 정보가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @race.destroy
    redirect_to admin_external_races_path, notice: "대회가 삭제되었습니다."
  end

  private

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: "권한이 없습니다."
    end
  end

  def set_race
    @race = ExternalRace.find(params[:id])
  end

  def race_params
    params.require(:external_race).permit(
      :title, :description, :race_date, :race_end_date,
      :location, :registration_url, :registration_deadline,
      :fee_info, :organizer_name, :status, distances: []
    )
  end
end
