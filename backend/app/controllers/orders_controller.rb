class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show]

  def index
    @orders = current_user.orders
                          .includes(order_items: { product: [:race, { images_attachments: :blob }] })
                          .order(created_at: :desc)
  end

  def show
    @order_items = @order.order_items.includes(product: [:race, { images_attachments: :blob }])
  end

  def new
    @cart = current_user.current_cart

    if @cart.empty?
      flash[:error] = '장바구니가 비어있습니다.'
      redirect_to cart_path
      return
    end

    # 재고 및 가용성 검증
    @cart.cart_items.each do |item|
      unless item.product.available?
        flash[:error] = "#{item.product.name}은(는) 현재 구매할 수 없습니다."
        redirect_to cart_path
        return
      end

      if item.quantity > item.product.stock
        flash[:error] = "#{item.product.name}의 재고가 부족합니다. (재고: #{item.product.stock}개)"
        redirect_to cart_path
        return
      end
    end

    @order = Order.new(
      user: current_user,
      race: @cart.cart_items.first.product.race # 첫 번째 상품의 대회
    )

    # 배송 정보 미리 채우기
    @order.shipping_address = current_user.address if current_user.address.present?
    @order.shipping_phone = current_user.phone if current_user.phone.present?
  end

  def create
    @cart = current_user.current_cart

    if @cart.empty?
      flash[:error] = '장바구니가 비어있습니다.'
      redirect_to cart_path
      return
    end

    # 주문 생성
    @order = Order.new(order_params)
    @order.user = current_user
    @order.race = @cart.cart_items.first.product.race

    ActiveRecord::Base.transaction do
      if @order.save
        # 장바구니 상품을 주문 항목으로 복사
        @cart.cart_items.each do |cart_item|
          @order.order_items.create!(
            product: cart_item.product,
            quantity: cart_item.quantity,
            unit_price: cart_item.unit_price
          )

          # 재고 차감
          cart_item.product.decrease_stock!(cart_item.quantity)
        end

        # 총액 계산
        @order.calculate_total!

        # 장바구니 비우기
        @cart.clear

        flash[:success] = '주문이 완료되었습니다!'
        redirect_to order_path(@order)
      else
        render :new
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:error] = e.record.errors.full_messages.join(', ')
    render :new
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:shipping_address, :shipping_phone)
  end
end
