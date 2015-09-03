class Metric::Caching
  class << self
    def fetch(metric)
      JSON.load $redis.get(key(metric))
    end

    def save(metric, data)
      $redis.set(key(metric), data.to_json)
      $redis.expire(key(metric), 1.hour.to_i)
    end

    private

    def key(metric)
      "metric-#{metric}"
    end
  end
end
