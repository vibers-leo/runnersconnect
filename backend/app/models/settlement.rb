class Settlement < ApplicationRecord
  belongs_to :organizer_profile
  belongs_to :race

  enum :status, {
    pending: 'pending',       # 정산 대기
    confirmed: 'confirmed',   # 정산 확정 (주최자 요청)
    approved: 'approved',     # 승인 (admin 확인)
    paid: 'paid',            # 지급 완료
    rejected: 'rejected'     # 거부
  }, default: :pending

  validates :total_revenue, :platform_commission, :organizer_payout, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :registration_count, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # 정산 금액 계산
  def calculate!
    registrations = race.registrations.where(status: 'paid')

    self.total_revenue = registrations.sum(:payment_amount)
    self.registration_count = registrations.count

    # 수수료 계산 (예: 5% + 건당 500원)
    commission_rate = 0.05
    commission_base_fee = 500

    self.platform_commission = (total_revenue * commission_rate).to_i + (commission_base_fee * registration_count)
    self.organizer_payout = total_revenue - platform_commission

    save!
  end

  # 정산 요청 가능 여부
  def can_request?
    pending? && total_revenue > 0
  end

  # 승인 가능 여부
  def can_approve?
    confirmed?
  end

  # 지급 가능 여부
  def can_mark_paid?
    approved?
  end
end
