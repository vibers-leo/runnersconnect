class Organizer::ProductsController < Organizer::BaseController
  before_action :set_race
  before_action :authorize_race_access!
  before_action :set_product, only: [:edit, :update, :destroy, :delete_image]

  def index
    @products = @race.products.order(created_at: :desc)
  end

  def new
    @product = @race.products.build
  end

  def create
    @product = @race.products.build(product_params)

    if @product.save
      flash[:success] = '상품이 등록되었습니다.'
      redirect_to organizer_race_products_path(@race)
    else
      flash.now[:error] = @product.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:success] = '상품이 수정되었습니다.'
      redirect_to organizer_race_products_path(@race)
    else
      flash.now[:error] = @product.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:success] = '상품이 삭제되었습니다.'
    redirect_to organizer_race_products_path(@race)
  end

  def delete_image
    image = @product.images.find(params[:image_id])
    image.purge
    flash[:success] = '이미지가 삭제되었습니다.'
    redirect_to edit_organizer_race_product_path(@race, @product)
  end

  private

  def set_race
    @race = current_organizer_profile.races.find(params[:race_id])
  end

  def set_product
    @product = @race.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :status, :size, :color, images: [])
  end

  def authorize_race_access!
    return if current_user.admin?
    return if @race.organizer.user_id == current_user.id

    redirect_to organizer_root_path, alert: '접근 권한이 없습니다.'
  end
end
