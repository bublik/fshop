class Admin::ShortUrlsController < AdminController
  before_action :set_short_url, only: [:edit, :update, :destroy]

  # GET /short_urls
  # GET /short_urls.json
  def index
    @short_urls = ShortUrl.page(params[:page]).per(10)
  end

  # GET /short_urls/new
  def new
    @short_url = ShortUrl.new
  end

  # GET /short_urls/1/edit
  def edit
  end

  # POST /short_urls
  # POST /short_urls.json
  def create
    @short_url = ShortUrl.new(short_url_params)

    respond_to do |format|
      if @short_url.save
        format.html { redirect_to admin_short_urls_path, notice: 'Short url was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /short_urls/1
  # PATCH/PUT /short_urls/1.json
  def update
    respond_to do |format|
      if @short_url.update(short_url_params)
        format.html { redirect_to admin_short_urls_path, notice: 'Short url was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /short_urls/1
  # DELETE /short_urls/1.json
  def destroy
    @short_url.destroy
    respond_to do |format|
      format.html { redirect_to admin_short_urls_path, notice: 'Short url was successfully destroyed.' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_short_url
    @short_url = ShortUrl.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def short_url_params
    params.require(:short_url).permit(:seo_url, :full_url, :title, :description, :keywords, :style_typs, :filter)
  end
end
