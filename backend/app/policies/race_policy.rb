class RacePolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    user&.admin? || user&.organizer?
  end

  def update?
    user&.admin? || organizer_of_race?
  end

  def destroy?
    user&.admin?
  end

  private

  def organizer_of_race?
    user&.organizer? && record.organizer&.user_id == user.id
  end
end
