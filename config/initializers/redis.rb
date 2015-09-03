redis_instance = Redis.new(
  host: ENV['redis_host'] || 'localhost',
  port: ENV['redis_port'] || '6830'
)

$redis = Redis::Namespace.new(
  ENV['redis_namespace'] || 'zst-cache',
  redis: redis_instance
)
