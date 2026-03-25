class Admin::RacesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_race, only: [:show, :edit, :update, :destroy]

  def index
    @races = Race.order(start_at: :desc).page(params[:page]).per(20)
  end

  def show
    @editions = @race.race_editions.order(display_order: :asc)
  end

  def new
    @race = Race.new
    @race.race_editions.build
  end

  def create
    @race = Race.new(race_params)

    if @race.save
      redirect_to admin_race_path(@race), notice: "대회가 성공적으로 생성되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @race.update(race_params)
      redirect_to admin_race_path(@race), notice: "대회가 성공적으로 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @race.destroy
    redirect_to admin_races_path, notice: "대회가 삭제되었습니다."
  end

  private

  def set_race
    @race = Race.find(params[:id])
  end

  def race_params
    params.require(:race).permit(
      :title,
      :description,
      :location,
      :start_at,
      :registration_start_at,
      :registration_end_at,
      :refund_deadline,
      :organizer_name,
      :official_site_url,
      :status,
      :is_official_record,
      :thumbnail_url,
      :thumbnail,
      race_editions_attributes: [:id, :name, :distance, :price, :capacity, :age_limit_min, :age_limit_max, :display_order, :_destroy]
    )
  end

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: "관리자 권한이 필요합니다."
    end
  end
end
