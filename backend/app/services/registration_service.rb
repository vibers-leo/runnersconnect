class RegistrationService
  def self.register(user:, race_edition:, payment_params: {})
    registration = Registration.new(
      user: user, race_edition: race_edition,
      payment_amount: race_edition.price,
      merchant_uid: generate_merchant_uid
    )

    if registration.save
      NotificationService.notify(user: user, action: 'registration', message: "#{race_edition.race.title} 참가 신청 완료")
      { success: true, registration: registration }
    else
      { success: false, errors: registration.errors.full_messages }
    end
  end

  def self.cancel(registration)
    return { success: false, error: '취소할 수 없는 상태입니다.' } unless registration.pending? || registration.paid?
    registration.update(status: 'cancelled')
    { success: true }
  end

  private

  def self.generate_merchant_uid
    "RC_#{Time.current.to_i}_#{SecureRandom.hex(4)}"
  end
end
