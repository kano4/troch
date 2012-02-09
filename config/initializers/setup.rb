$redis = Redis.new
begin
  $redis.ping
rescue
  raise "Please start Redis"
end
#`RAILS_ENV="#{ENV['RAILS_ENV']}" #{Rails.root}/script/troch_server restart`
`bundle exec whenever --update troch --set environment="#{ENV['RAILS_ENV']}"`
