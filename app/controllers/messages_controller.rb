class MessagesController < AdminController
  def show
    message_id = params[:id]
    raw = events_api.message(message_id)
    @message = Message.new(raw).decorate
  rescue Faraday::ResourceNotFound
    head :not_found
  end
end
