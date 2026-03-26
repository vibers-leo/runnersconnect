class RaceManagementService
  def self.open_registration(race)
    return { success: false, error: '이미 접수 중입니다.' } if race.open?
    race.update!(status: 'open')
    { success: true }
  end

  def self.close_registration(race)
    race.update!(status: 'closed')
    NotificationService.notify_race_update(race, "#{race.title} 접수가 마감되었습니다.")
    { success: true }
  end

  def self.finish(race)
    race.update!(status: 'finished')
    # 자동 정산 생성
    create_settlement(race) if race.organizer.present?
    { success: true }
  end

  private

  def self.create_settlement(race)
    settlement = Settlement.find_or_create_by!(
      organizer_profile: race.organizer, race: race
    )
    SettlementService.calculate(settlement)
  end
end
