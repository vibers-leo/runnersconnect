class ProductsController < ApplicationController
  before_action :set_race, only: [:index]
  before_action :set_product, only: [:show]

  def index
    @race = Race.find(params[:race_id])
    @products = @race.products
                     .where(status: 'active')
                     .where('stock > 0')
                     .order(created_at: :desc)

    # 카테고리별 필터링 (향후 확장)
    if params[:category].present?
      @products = @products.where(category: params[:category])
    end
  end

  def show
    @product = Product.find(params[:id])
    @race = @product.race
    @related_products = @race.products
                             .where(status: 'active')
                             .where('stock > 0')
                             .where.not(id: @product.id)
                             .limit(4)
  end

  private

  def set_race
    @race = Race.find(params[:race_id])
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
