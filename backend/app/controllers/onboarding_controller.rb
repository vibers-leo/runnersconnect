class OnboardingController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_completed

  def show
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(onboarding_params)
      @user.update(onboarding_completed: true)
      redirect_to root_path, notice: "환영합니다, #{@user.display_name}님! 🎉 러너스 커넥트에 오신 것을 환영합니다."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def skip
    current_user.update(onboarding_completed: true)
    redirect_to root_path, notice: "나중에 프로필을 완성해보세요!"
  end

  private

  def onboarding_params
    params.require(:user).permit(:nickname, :gender, :region, :age_group, :avatar)
  end

  def redirect_if_completed
    redirect_to root_path if current_user.onboarding_completed?
  end
end
