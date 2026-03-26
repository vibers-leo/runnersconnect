class OrderPolicy < ApplicationPolicy
  def show?
    owner? || user&.admin?
  end

  def cancel?
    owner? && record.pending?
  end
end
