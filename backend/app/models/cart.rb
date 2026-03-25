class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_product(product, quantity = 1)
    current_item = cart_items.find_by(product_id: product.id)

    if current_item
      current_item.quantity += quantity
      current_item.save
    else
      cart_items.create(
        product: product,
        quantity: quantity,
        unit_price: product.price
      )
    end
  end

  def remove_product(product)
    cart_items.find_by(product_id: product.id)&.destroy
  end

  def update_quantity(product, quantity)
    item = cart_items.find_by(product_id: product.id)
    return unless item

    if quantity <= 0
      item.destroy
    else
      item.update(quantity: quantity)
    end
  end

  def total_amount
    cart_items.sum(:subtotal)
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def empty?
    cart_items.empty?
  end

  def clear
    cart_items.destroy_all
  end
end
