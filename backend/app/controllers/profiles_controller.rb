class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @registrations_count = @user.registrations.count
    @total_records = @user.records.count
    
    # Calculate PBs for dashboard
    @pb_5k = @user.records.where("race_editions.distance = ?", RaceEdition::DISTANCE_5K).joins(:race_edition).minimum(:net_time)
    @pb_10k = @user.records.where("race_editions.distance = ?", RaceEdition::DISTANCE_10K).joins(:race_edition).minimum(:net_time)
    @pb_half = @user.records.where("race_editions.distance = ?", RaceEdition::DISTANCE_HALF).joins(:race_edition).minimum(:net_time)
    @pb_full = @user.records.where("race_editions.distance = ?", RaceEdition::DISTANCE_FULL).joins(:race_edition).minimum(:net_time)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: '프로필이 업데이트되었습니다.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :nickname, :phone_number, :address_zipcode, :address_basic, :address_detail, :birth_date, :gender, :region, :age_group, :avatar)
  end
end
