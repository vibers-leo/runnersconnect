class Organizer::SettlementsController < Organizer::BaseController
  before_action :set_settlement, only: [:show, :request_payout]

  def index
    @settlements = current_organizer_profile.settlements
                                            .includes(:race)
                                            .order(created_at: :desc)

    # 통계
    @pending_total = @settlements.where(status: ['pending', 'confirmed', 'approved']).sum(:organizer_payout)
    @paid_total = @settlements.where(status: 'paid').sum(:organizer_payout)
  end

  def show
    # 상세 정산 내역
  end

  def request_payout
    if @settlement.can_request?
      @settlement.calculate!  # 최신 금액으로 재계산
      @settlement.update!(status: 'confirmed', requested_at: Time.current)

      # Admin에게 이메일 알림 발송
      AdminMailer.settlement_requested(@settlement).deliver_later

      flash[:success] = '정산 요청이 완료되었습니다. 영업일 기준 3-5일 내 처리됩니다.'
    else
      flash[:error] = '정산을 요청할 수 없습니다.'
    end

    redirect_to organizer_settlements_path
  end

  private

  def set_settlement
    @settlement = current_organizer_profile.settlements.find(params[:id])
  end
end
