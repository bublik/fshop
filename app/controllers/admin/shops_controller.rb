class Admin::ShopsController < AdminController
  before_action :set_shop, only: [:show, :edit, :update, :destroy]

  def index
    @shops = Shop.all.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @shop = Shop.new
  end

  def edit
  end

  def create
    @shop = Shop.new(shop_params)

    respond_to do |format|
      if @shop.save
        format.html { redirect_to admin_shops_url, notice: 'Shop was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to admin_shops_url, notice: 'Shop was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @shop.destroy
    respond_to do |format|
      format.html { redirect_to admin_shops_url, notice: 'Shop was successfully destroyed.' }
    end
  end

  private
  def set_shop
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(:name, :logo, :target_url, :shipping, :affiliate_network_id, :affiliate_network_merchant_id)
  end
end
