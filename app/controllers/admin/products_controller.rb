class Admin::ProductsController < AdminController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.opened.includes(:shop).page(params[:page]).per(10)
  end

  def verification
    Product.friendly.find(params[:disable_ids]).map(&:hide!) if params[:disable_ids]

    @products = Product.draft.includes(:shop)
    @products = @products.where(shop_id: params[:shop_id]) if params[:shop_id]
    @products = @products.page(params[:page]).per(5)
  end

  def identification
    @product = Product.identified
    @product = @product.where(shop_id: params[:shop_id]) if params[:shop_id].present?
    @product = @product.first

    if @product
      @product = @product.decorate
      session[:back_path] = identification_admin_products_path
      render :edit
    else
      redirect_to admin_path, notice: 'No pending products!'
    end
  end

  def edit
    session[:back_path] = request.referrer
  end

  def update
    if params[:state].eql?('verify')
      if @product.verified? || @product.identified?
        @product.draft!
      else
        @product.verify!
      end
    else
      params.permit!

      if @product.update(params[:product])
        @product.publish! unless @product.published?
      end
    end

    respond_to do |format|
      format.html { @product.valid? ? redirect_to(session[:back_path] || identification_admin_products_path) : render(:edit) }
      format.js {}
    end
  end

  def destroy
    @product.hide!
    respond_to do |format|
      format.html { redirect_to(request.referrer.to_s.match('identification') ? identification_admin_products_path : admin_products_path) }
      format.js {}
    end
  end

  private

  def set_product
    @product = params[:id].present? ? Product.friendly.find(params[:id]).decorate : nil
  end

end
