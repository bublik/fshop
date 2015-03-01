Sidekiq.configure_server do |config|
  config.redis = {:url => Rails.application.secrets.redis, :namespace => 'sidekiq', :size => 15}
  config.poll_interval = 5
end

Sidekiq.configure_client do |config|
  config.redis = {:url => Rails.application.secrets.redis, :namespace => 'sidekiq', :size => 3}
end

# Require all existing scheduled jobs
Dir[Rails.root.join "app/workers/*.rb"].each { |f| require f }
