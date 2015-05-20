class EventsApi
  API_VERSION = 1

  attr_reader :connection

  def api_base_url
    Figaro.env.events_api_base_url
  end

  def initialize
    @connection = Faraday.new(api_base_url) do |c|
      c.request :json
      c.response :json, content_type: /\bjson$/
      c.response :raise_error
      c.adapter Faraday.default_adapter
    end
  end

  def metric_path(metric)
    File.join('api', "v#{API_VERSION}", 'metrics', metric.to_s)
  end

  def metric_data(metric, options = {})
    @connection.get(metric_path(metric), options).body
  end

  def metric_list_path
    File.join('api', "v#{API_VERSION}", 'metrics')
  end

  def metric_list(options = {})
    @connection.get(metric_list_path, options).body
  end
end
