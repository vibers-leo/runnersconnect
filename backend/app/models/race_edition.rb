class RaceEdition < ApplicationRecord
  # Distance Constants
  DISTANCE_5K = 5
  DISTANCE_10K = 10
  DISTANCE_HALF = 21.0975
  DISTANCE_FULL = 42.195

  # Associations
  belongs_to :race
  has_many :registrations
  has_many :records

  # Validations
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  
  # Logic to check capacity
  def full?
    return false if capacity.zero? || capacity.nil? # Unlimited
    current_count >= capacity
  end

  def remaining_slots
    return 9999 if capacity.zero? || capacity.nil?
    [capacity - current_count, 0].max
  end
end
