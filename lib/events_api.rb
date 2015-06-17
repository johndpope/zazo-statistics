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

  def namespace
    "api/v#{API_VERSION}"
  end

  def metric_path(metric)
    File.join(namespace, 'metrics', metric.to_s)
  end

  def metric_data(metric, options = {})
    @connection.post(metric_path(metric), options).body
  end

  def metric_list_path
    File.join(namespace, 'metrics')
  end

  def metric_list(options = {})
    @connection.get(metric_list_path, options).body
  end

  def events_path
    File.join(namespace, 'events')
  end

  def filter_by(term, options = {})
    @connection.get(events_path, options.reverse_merge(filter_by: term)).body
  end

  def messages_path
    File.join(namespace, 'messages')
  end

  def messages(options = {})
    @connection.get(messages_path, options).body
  end

  def message_path(id)
    File.join(namespace, 'messages', id)
  end

  def message(id, options = {})
    @connection.get(message_path(id), options).body
  end

  def message_events_path(id)
    File.join(namespace, 'messages', id, 'events')
  end

  def message_events(id, options = {})
    @connection.get(message_events_path(id), options).body
  end
end
