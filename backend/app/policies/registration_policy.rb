class RegistrationPolicy < ApplicationPolicy
  def show?
    owner? || race_organizer? || user&.admin?
  end

  def create?
    user.present?
  end

  def cancel?
    owner? && (record.pending? || record.paid?)
  end

  private

  def race_organizer?
    user&.organizer? && record.race_edition.race.organizer&.user_id == user.id
  end
end
