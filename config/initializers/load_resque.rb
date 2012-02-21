require 'resque'

$redis = Redis.new
begin
  $redis.ping
rescue
  raise "Please start Redis"
end

Resque.redis = 'localhost:6379'
