class SettlementPolicy < ApplicationPolicy
  def index?
    user&.admin? || user&.organizer?
  end

  def show?
    user&.admin? || settlement_organizer?
  end

  def approve?
    user&.admin?
  end

  def mark_paid?
    user&.admin?
  end

  def request_payout?
    settlement_organizer?
  end

  private

  def settlement_organizer?
    record.organizer_profile.user_id == user&.id
  end
end
