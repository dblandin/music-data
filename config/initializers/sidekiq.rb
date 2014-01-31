Sidekiq.configure_server do |config|
  config.redis = {
    url:       ENV['REDIS_URL'],
    namespace: ENV['SIDEKIQ_NAMESPACE']
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url:       ENV['REDIS_URL'],
    namespace: ENV['SIDEKIQ_NAMESPACE'],
    timeout:   1,
    size:      16
  }
end
