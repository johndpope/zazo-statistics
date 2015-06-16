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
    @connection.post(metric_path(metric), options).body
  end

  def metric_list_path
    File.join('api', "v#{API_VERSION}", 'metrics')
  end

  def metric_list(options = {})
    @connection.get(metric_list_path, options).body
  end

  def events_path
    File.join('api', "v#{API_VERSION}", 'events')
  end

  def filter_by(term, options = {})
    @connection.get(events_path, options.reverse_merge(filter_by: term)).body
  end

  def messages_path
    File.join('api', "v#{API_VERSION}", 'messages')
  end

  def messages(options = {})
    @connection.get(messages_path, options).body
  end
end
