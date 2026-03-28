class OrganizerProfile < ApplicationRecord
  belongs_to :user
  has_many :races, foreign_key: 'organizer_id', dependent: :nullify
  has_many :settlements, dependent: :destroy

  # Validations
  validates :business_name, presence: true
  validates :contact_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :contact_phone, presence: true

  # Settlement information validations (optional until needed)
  validates :bank_account, presence: true, if: :settlement_info_required?
  validates :bank_name, presence: true, if: :settlement_info_required?
  validates :account_holder, presence: true, if: :settlement_info_required?

  # 주최자의 전체 참가자 수 (결제 완료 기준)
  def total_participants_count
    races.joins(:registrations).where(registrations: { status: 'paid' }).count
  end

  private

  def settlement_info_required?
    # Require settlement info only when organizer has races with paid registrations
    races.joins(:registrations).where(registrations: { status: 'paid' }).exists?
  end
end
