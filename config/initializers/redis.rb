require 'redis'
require 'hiredis'

$redis = Redis.new(url: ENV['REDIS_URL'], driver: :hiredis)

