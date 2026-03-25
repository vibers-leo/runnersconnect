class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(product: [:race, { images_attachments: :blob }])
  end

  def add_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity]&.to_i || 1

    if product.available?
      @cart.add_product(product, quantity)
      flash[:success] = "#{product.name}이(가) 장바구니에 추가되었습니다."
      redirect_to cart_path
    else
      flash[:error] = '현재 구매할 수 없는 상품입니다.'
      redirect_to product_path(product)
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = e.record.errors.full_messages.join(', ')
    redirect_to product_path(product)
  end

  def update_quantity
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    @cart.update_quantity(product, quantity)

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.json {
        render json: {
          success: true,
          total_items: @cart.total_items,
          total_amount: @cart.total_amount,
          item_subtotal: @cart.cart_items.find_by(product_id: product.id)&.subtotal
        }
      }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html do
        flash[:error] = e.record.errors.full_messages.join(', ')
        redirect_to cart_path
      end
      format.json { render json: { success: false, error: e.record.errors.full_messages.join(', ') }, status: :unprocessable_entity }
    end
  end

  def remove_item
    product = Product.find(params[:product_id])
    @cart.remove_product(product)

    flash[:success] = '상품이 장바구니에서 제거되었습니다.'
    redirect_to cart_path
  end

  def clear
    @cart.clear
    flash[:success] = '장바구니가 비워졌습니다.'
    redirect_to cart_path
  end

  private

  def set_cart
    @cart = current_user.current_cart
  end
end
