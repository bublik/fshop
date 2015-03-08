class LoaderWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true, queue: 'high'

  def perform(feed_id)
    Rails.logger.info("Start load feed #{feed_id}")
    feed = DataFeed.find(feed_id)
    feed.store_data
  end
end