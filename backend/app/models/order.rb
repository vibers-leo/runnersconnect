class Order < ApplicationRecord
  belongs_to :user
  belongs_to :race
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :order_number, presence: true, uniqueness: true

  enum :status, {
    pending: 'pending',
    paid: 'paid',
    shipped: 'shipped',
    delivered: 'delivered',
    cancelled: 'cancelled'
  }, default: :pending

  before_create :generate_order_number

  def calculate_total!
    self.total_amount = order_items.sum(:subtotal)
    save!
  end

  private

  def generate_order_number
    self.order_number = "ORD#{Time.current.to_i}#{rand(1000..9999)}"
  end
end
