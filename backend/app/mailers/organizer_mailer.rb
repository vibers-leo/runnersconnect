class OrganizerMailer < ApplicationMailer
  default from: 'noreply@runnersconnect.com'

  # 정산 승인 알림
  def settlement_approved(settlement)
    @settlement = settlement
    @organizer = settlement.organizer_profile
    @race = settlement.race

    mail(
      to: @organizer.contact_email,
      subject: "[Runner's Connect] #{@race.title} 정산이 승인되었습니다"
    )
  end

  # 정산 거부 알림
  def settlement_rejected(settlement)
    @settlement = settlement
    @organizer = settlement.organizer_profile
    @race = settlement.race

    mail(
      to: @organizer.contact_email,
      subject: "[Runner's Connect] #{@race.title} 정산 요청이 거부되었습니다"
    )
  end

  # 정산 지급 완료 알림
  def settlement_paid(settlement)
    @settlement = settlement
    @organizer = settlement.organizer_profile
    @race = settlement.race

    mail(
      to: @organizer.contact_email,
      subject: "[Runner's Connect] #{@race.title} 정산금이 지급되었습니다"
    )
  end
end
