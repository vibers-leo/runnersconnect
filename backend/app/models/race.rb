class Race < ApplicationRecord
  # Associations
  belongs_to :organizer, class_name: 'OrganizerProfile', optional: true
  has_many :race_editions, dependent: :destroy
  has_many :registrations, through: :race_editions
  has_many :records
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :restrict_with_error
  accepts_nested_attributes_for :race_editions, allow_destroy: true, reject_if: :all_blank

  # Active Storage
  has_one_attached :thumbnail do |attachable|
    attachable.variant :medium, resize_to_limit: [800, 600]
    attachable.variant :thumb, resize_to_limit: [400, 300]
  end

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :start_at, presence: true
  validates :location, presence: true
  validates :status, presence: true, inclusion: { in: %w[draft open closed finished] }
  validate :registration_period_validity
  validate :refund_deadline_before_start
  validate :thumbnail_size

  def thumbnail_url
    return thumbnail_url_attribute if thumbnail_url_attribute.present?
    return nil unless thumbnail.attached?
    Rails.application.routes.url_helpers.rails_blob_url(thumbnail, only_path: true)
  end

  # Scopes
  scope :upcoming, -> { where('start_at > ?', Time.current).order(start_at: :asc) }
  scope :open_for_registration, -> {
    where('registration_start_at <= ? AND registration_end_at >= ?', Time.current, Time.current)
  }

  # Status Management
  enum :status, { draft: 'draft', open: 'open', closed: 'closed', finished: 'finished' }, default: 'draft'

  def registration_open?
    return false unless status == 'open'
    return false if registration_start_at.nil? || registration_end_at.nil?

    registration_start_at <= Time.current && registration_end_at >= Time.current
  end

  # 추천 대회 (같은 지역, 비슷한 시기)
  def related_races
    Race.where.not(id: id)
        .where('start_at BETWEEN ? AND ?', start_at - 2.months, start_at + 2.months)
        .where(status: 'open')
        .order(start_at: :asc)
        .limit(5)
  end

  # 같은 주최자의 다른 대회
  def organizer_other_races
    return Race.none if organizer.nil?

    organizer.races.where.not(id: id)
                   .where(status: 'open')
                   .order(start_at: :asc)
                   .limit(3)
  end

  private

  def registration_period_validity
    return if registration_start_at.blank? || registration_end_at.blank?

    if registration_start_at >= registration_end_at
      errors.add(:registration_end_at, "접수 종료일은 접수 시작일 이후여야 합니다")
    end
  end

  def refund_deadline_before_start
    return if refund_deadline.blank? || start_at.blank?

    if refund_deadline >= start_at
      errors.add(:refund_deadline, "환불 마감일은 대회 시작일 이전이어야 합니다")
    end
  end

  def thumbnail_size
    return unless thumbnail.attached?

    if thumbnail.blob.byte_size > 5.megabytes
      errors.add(:thumbnail, "파일 크기는 5MB 이하여야 합니다")
    end
  end

  def thumbnail_url_attribute
    read_attribute(:thumbnail_url)
  end
end
