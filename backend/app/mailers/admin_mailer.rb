class AdminMailer < ApplicationMailer
  default from: 'noreply@runnersconnect.com'

  # 새로운 정산 요청 알림
  def settlement_requested(settlement)
    @settlement = settlement
    @organizer = settlement.organizer_profile
    @race = settlement.race

    # Admin 이메일 주소들 (환경변수 또는 설정에서 가져오기)
    admin_emails = User.where(role: 'admin').pluck(:email)

    mail(
      to: admin_emails,
      subject: "[Runner's Connect Admin] 새로운 정산 요청: #{@race.title}"
    )
  end
end
