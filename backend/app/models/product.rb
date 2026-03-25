class Product < ApplicationRecord
  belongs_to :race
  has_many :order_items, dependent: :restrict_with_error
  has_many_attached :images

  validates :name, :price, :stock, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  enum :status, { active: 'active', inactive: 'inactive', sold_out: 'sold_out' }, default: :active

  def available?
    active? && stock > 0
  end

  def decrease_stock!(quantity)
    update!(stock: stock - quantity)
  end
end
