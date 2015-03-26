class ProductsController < ApplicationController
  layout 'application'
  before_action :set_class, only: [:index, :search]

  def index
    @products = Product.opened
    @products = @products.where(type: params[:type]) if params[:type].present?
    @products = @products.page(params[:page]).per(30)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def short
    if @page = ShortUrl.where(seo_url: params[:seo_url]).first
      @products = Product.search(@page.filter.dup).page(params[:page]).records
      @selected_tags = @page.filter.except('price').values.flatten
      render :index
    else
      render file: 'home/page_404', status: 404
    end
  end

  def search
    @products = if params[:tag_name].present?
      Product.where(type: params[:type]).tagged_with(params[:tag_name]).page(params[:page]).per(30)
    else
      condition = ''
      if params[:q]
        condition = params[:q]
      end
      if params[:category]
        flash[:notice] = 'Category Filter not implemented yet'
        condition = '*'
      end
      if params[:product]
        condition = params[:product]
        condition[:q] = params[:q] if params[:q]
      end
      params[:type].constantize.search(condition.blank? ? '*' : condition).page(params[:page]).records
    end

    render :index
  end

  def show
    if @product = Product.friendly.includes(:shop).find(params[:id])
      @shop = Shop.find(@product.shop_id)
      @coupons = @shop.coupons.all
      @product = @product.decorate
    else
      redirect_to(root_path, notice: 'Product not found!')
    end
  end

  def go
    @redirect_url = params[:url]
    @shop = Shop.find(params[:shop_id])
    if params[:coupon_id] && (@coupon = Coupon.find(params[:coupon_id]))
      @redirect_url = @coupon.target_url unless @coupon.target_url.blank?
    end

    if @redirect_url.blank?
      redirect_to root_path, notice: 'Url not found, please contact to support!'
      return
    end
    render layout: 'simple'
  end

  private
  def set_class
    @product_class = (params[:type] || 'Product').constantize
  end
end

