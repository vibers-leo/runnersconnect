class Registration < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :race_edition
  belongs_to :crew, optional: true
  has_one :race, through: :race_edition

  # Validations
  validates :merchant_uid, presence: true, uniqueness: true
  validates :payment_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, uniqueness: { scope: :race_edition_id, message: "이미 해당 대회에 신청하셨습니다." }
  
  # Status
  enum :status, { pending: 'pending', paid: 'paid', cancelled: 'cancelled', refunded: 'refunded' }, default: 'pending'
  enum :shipping_status, { preparing: 'preparing', shipped: 'shipped', delivered: 'delivered', picked_up: 'picked_up' }, default: 'preparing'

  # Scopes for souvenir tracking
  scope :souvenir_received, -> { where.not(souvenir_received_at: nil) }
  scope :souvenir_pending, -> { where(souvenir_received_at: nil) }
  scope :medal_received, -> { where.not(medal_received_at: nil) }
  scope :medal_pending, -> { where(medal_received_at: nil) }

  # Callbacks
  before_create :generate_qr_token
  after_create :increment_edition_count

  # 등번호 관리 메서드
  def self.bulk_reassign_bib_numbers(race_edition_id)
    registrations = where(race_edition_id: race_edition_id, status: 'paid')
                    .order(created_at: :asc)

    registrations.each_with_index do |reg, index|
      reg.update_column(:bib_number, index + 1)
    end
  end

  def can_change_bib_number?
    ['pending', 'paid'].include?(status) && race.start_at > Time.current
  end

  def mark_souvenir_received!(staff_name)
    update!(
      souvenir_received_at: Time.current,
      souvenir_received_by: staff_name
    )
  end

  def mark_medal_received!(staff_name)
    update!(
      medal_received_at: Time.current,
      medal_received_by: staff_name
    )
  end

  private

  def generate_qr_token
    self.qr_token = SecureRandom.hex(12)
  end

  def increment_edition_count
    race_edition.increment!(:current_count)
  end
end
