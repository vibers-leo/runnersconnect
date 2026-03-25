class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @total_users = User.count
    @total_registrations = Registration.count
    @total_sales = Registration.where(status: 'paid').sum(:payment_amount)
    @recent_registrations = Registration.includes(:user, race_edition: :race).order(created_at: :desc).limit(10)

    @users_today = User.where("created_at >= ?", Time.current.beginning_of_day).count
    @active_races = Race.where(status: 'open').count

    this_month = Registration.where(status: 'paid')
                             .where("paid_at >= ?", Time.current.beginning_of_month)
                             .sum(:payment_amount)
    last_month = Registration.where(status: 'paid')
                             .where(paid_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)
                             .sum(:payment_amount)
    @sales_trend = last_month > 0 ? ((this_month - last_month).to_f / last_month * 100).round(1) : 0
  end

  private

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: '권한이 없습니다.'
    end
  end
end
