class Admin::SettlementsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_settlement, only: [:approve, :reject, :mark_paid]

  def index
    @pending_settlements = Settlement.includes(:organizer_profile, :race)
                                     .where(status: 'confirmed')
                                     .order(requested_at: :asc)

    @approved_settlements = Settlement.includes(:organizer_profile, :race)
                                      .where(status: 'approved')
                                      .order(approved_at: :desc)
                                      .limit(10)

    @paid_settlements = Settlement.includes(:organizer_profile, :race)
                                  .where(status: 'paid')
                                  .order(paid_at: :desc)
                                  .limit(10)

    # 통계
    @pending_total = @pending_settlements.sum(:organizer_payout)
    @approved_total = Settlement.where(status: 'approved').sum(:organizer_payout)
    @paid_total = Settlement.where(status: 'paid').sum(:organizer_payout)
  end

  def approve
    if @settlement.confirmed?
      @settlement.update!(
        status: 'approved',
        approved_at: Time.current
      )

      # 주최자에게 승인 알림 이메일 발송
      OrganizerMailer.settlement_approved(@settlement).deliver_later

      flash[:success] = '정산이 승인되었습니다. 주최자에게 이메일이 발송되었습니다.'
    else
      flash[:error] = '이미 처리된 정산입니다.'
    end

    redirect_to admin_settlements_path
  end

  def reject
    if @settlement.confirmed?
      @settlement.update!(
        status: 'rejected',
        admin_memo: params[:reason]
      )

      # 주최자에게 거부 알림 이메일 발송
      OrganizerMailer.settlement_rejected(@settlement).deliver_later

      flash[:success] = '정산이 거부되었습니다. 주최자에게 이메일이 발송되었습니다.'
    else
      flash[:error] = '이미 처리된 정산입니다.'
    end

    redirect_to admin_settlements_path
  end

  def mark_paid
    if @settlement.approved?
      @settlement.update!(
        status: 'paid',
        paid_at: Time.current
      )

      # 주최자에게 지급 완료 알림 이메일 발송
      OrganizerMailer.settlement_paid(@settlement).deliver_later

      flash[:success] = '정산 지급이 완료되었습니다. 주최자에게 이메일이 발송되었습니다.'
    else
      flash[:error] = '승인된 정산만 지급 처리할 수 있습니다.'
    end

    redirect_to admin_settlements_path
  end

  private

  def set_settlement
    @settlement = Settlement.find(params[:id])
  end

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: '권한이 없습니다.'
    end
  end
end
