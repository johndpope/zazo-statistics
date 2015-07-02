class MessagesController < AdminController
  def index
    raw = events_api.messages(messages_params)
    @sender = User.find_by_mkey(messages_params[:sender_id])
    @receiver = User.find_by_mkey(messages_params[:receiver_id])
    @messages = raw.map { |m| Message.new(m).decorate }
  end

  def show
    message_id = params[:id]
    raw = events_api.message(message_id)
    @message = Message.new(raw).decorate
  rescue Faraday::ResourceNotFound
    head :not_found
  end

  private

  def messages_params
    params.permit(:sender_id, :receiver_id, :reverse, :page, :per, :filter)
  end
end
