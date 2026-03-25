class Organizer::PaymentsController < Organizer::BaseController
  before_action :set_race
  before_action :authorize_race_access!

  def index
    @registrations = @race.registrations.includes(:user, :race_edition)

    # 통계
    @total_revenue = @registrations.where(status: 'paid').sum(:payment_amount)
    @paid_count = @registrations.where(status: 'paid').count
    @pending_count = @registrations.where(status: 'pending').count
    @refunded_count = @registrations.where(status: 'refunded').count

    # 종목별 수익
    @revenue_by_edition = {}
    @race.race_editions.each do |edition|
      revenue = @registrations.where(race_edition_id: edition.id, status: 'paid').sum(:payment_amount)
      paid_count = @registrations.where(race_edition_id: edition.id, status: 'paid').count
      @revenue_by_edition[edition] = { revenue: revenue, count: paid_count }
    end

    # 일별 신청/결제 추이 (최근 30일)
    @registrations_by_date = @registrations.where(status: 'paid')
                                          .where('created_at >= ?', 30.days.ago)
                                          .group("DATE(created_at)")
                                          .count

    # 최근 결제 내역
    @recent_payments = @registrations.where(status: 'paid')
                                     .order(created_at: :desc)
                                     .limit(20)
  end

  private

  def set_race
    @race = current_organizer_profile.races.find(params[:race_id])
  end

  def authorize_race_access!
    return if current_user.admin?
    return if @race.organizer.user_id == current_user.id

    redirect_to organizer_root_path, alert: '접근 권한이 없습니다.'
  end
end
