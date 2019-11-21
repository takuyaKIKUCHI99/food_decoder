class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update]
  skip_before_action :authenticate_user!

  def show
    restrictions = Restriction.all.first(28)
    if user_signed_in?
      @allergens = current_user.restrictions.map do |restriction|
        restriction.name
      end
    else
      @allergens = restrictions.map do |restriction|
        restriction.name
      end
    end
  end

  def new
    @product = Product.new()
    authorize @product
  end

  def create
    @product = Product.new(product_params)
    authorize @product
    if @product.save
      redirect_to product_path(@product)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @product.update(product_params)
    redirect_to product_path(@product)
  end

  private

  def set_product
    @product = Product.find(params[:id])
    authorize @product
  end

  def product_params
    params.require(:product).permit(:name, :label_photo, :front_photo)
  end
end
