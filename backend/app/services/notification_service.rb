class NotificationService
  def self.notify(user:, action:, message:, data: {})
    Rails.logger.info "[Notification] #{action}: #{message} (user: #{user&.id})"
    # Future: ActionCable, push notification
  end

  def self.notify_settlement_update(settlement)
    user = settlement.organizer_profile.user
    notify(user: user, action: 'settlement', message: "정산 상태: #{settlement.status}")
  end

  def self.notify_race_update(race, message)
    race.registrations.includes(:user).find_each do |reg|
      notify(user: reg.user, action: 'race_update', message: message)
    end
  end
end
