class ThumbWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true, queue: 'high'

  def perform(product_id)
    Rails.logger.info("Build Thumb for #{product_id}")
    Product.create_thumb(product_id)
  end
end