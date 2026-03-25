class Record < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :race_edition
  belongs_to :registration, optional: true

  # Validations
  validates :net_time, presence: true

  # Scopes
  scope :verified, -> { where(is_verified: true) }
  scope :by_edition, ->(edition_id) { where(race_edition_id: edition_id).order(net_time: :asc) }
end
