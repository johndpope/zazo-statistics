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

  def messages_sent_path
    File.join('api', "v#{API_VERSION}", '/engagement/messages_sent')
  end

  def messages_sent(options = {})
    @connection.get(messages_sent_path, options).body
  end
end
