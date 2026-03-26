class SettlementService
  COMMISSION_RATE = 0.05
  COMMISSION_PER_REGISTRATION = 500

  def self.calculate(settlement)
    registrations = settlement.race.registrations.where(status: 'paid')
    total = registrations.sum(:payment_amount)
    count = registrations.count
    commission = (total * COMMISSION_RATE).to_i + (COMMISSION_PER_REGISTRATION * count)

    settlement.update!(
      total_revenue: total, registration_count: count,
      platform_commission: commission, organizer_payout: total - commission
    )
  end

  def self.request_payout(settlement)
    return { success: false, error: '정산 요청 불가' } unless settlement.can_request?
    settlement.update!(status: 'confirmed', requested_at: Time.current)
    { success: true }
  end

  def self.approve(settlement)
    return { success: false, error: '승인 불가' } unless settlement.can_approve?
    settlement.update!(status: 'approved', approved_at: Time.current)
    { success: true }
  end

  def self.mark_paid(settlement)
    return { success: false, error: '지급 처리 불가' } unless settlement.can_mark_paid?
    settlement.update!(status: 'paid', paid_at: Time.current)
    { success: true }
  end
end
