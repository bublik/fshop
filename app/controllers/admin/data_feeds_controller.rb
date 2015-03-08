class Admin::DataFeedsController < AdminController
  before_action :set_data_feed, only: [:show, :edit, :update, :destroy]
  before_action :set_shop

  def index
    @data_feeds = @shop.data_feeds
  end

  def new
    @data_feed = DataFeed.new(shop_id: params[:shop_id])
  end

  def edit
  end

  def start_sync
    LoaderWorker.perform_async(params[:id])
    redirect_to({action: :index}, notice: 'Синхронизация отправлена в очередь.')
  end

  def create
    @data_feed = DataFeed.new(data_feed_params)

    respond_to do |format|
      if @data_feed.save
        format.html { redirect_to admin_shop_data_feeds_path(@data_feed.shop), notice: 'Data feed was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @data_feed.update(data_feed_params)
        format.html { redirect_to admin_shop_data_feeds_path(@data_feed.shop), notice: 'Data feed was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @data_feed.destroy
    respond_to do |format|
      format.html { redirect_to admin_shop_data_feeds_path(@data_feed.shop), notice: 'Data feed was successfully destroyed.' }
    end
  end

  private
  def set_data_feed
    @data_feed = DataFeed.find(params[:id])
    @shop = @data_feed.shop
  end

  def set_shop
    @shop = params[:shop_id].present? ? Shop.find(params[:shop_id]).decorate : nil
  end

  def data_feed_params
    params.require(:data_feed).permit(:shop_id, :url, :feed_type)
  end
end
