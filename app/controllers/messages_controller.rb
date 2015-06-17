class MessagesController < AdminController
  def show
    message_id = params[:id]
    raw = events_api.message(message_id)
    @message = MessageDecorator.new(Message.new(raw))
    @events = EventDecorator.decorate_collection(@message.events)
  rescue Faraday::ResourceNotFound
    head :not_found
  end
end
