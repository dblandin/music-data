require 'redis'
require 'hiredis'

module Clockwork
  API_KEYS = ['493b35696b6907219cca0c19c9170fed', 'af9dcd7846bef3fc7980542409f79e69']

  handler do |api_key|
    redis = Redis.new(url: ENV['REDIS_URL'], driver: :hiredis)

    redis.set("rate-#{api_key}", 0)
  end

  API_KEYS.each { |api_key| every(1.minute, api_key) }
end
