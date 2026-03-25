class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true
  validates :product_id, uniqueness: { scope: :cart_id }
  validate :product_must_be_available
  validate :quantity_must_not_exceed_stock

  before_validation :set_unit_price
  before_validation :calculate_subtotal

  private

  def set_unit_price
    self.unit_price = product.price if product
  end

  def calculate_subtotal
    self.subtotal = quantity * unit_price if quantity && unit_price
  end

  def product_must_be_available
    return unless product

    unless product.available?
      errors.add(:product, '는 현재 구매할 수 없습니다 (품절 또는 판매 중지)')
    end
  end

  def quantity_must_not_exceed_stock
    return unless product && quantity

    if quantity > product.stock
      errors.add(:quantity, "는 재고(#{product.stock}개)를 초과할 수 없습니다")
    end
  end
end
