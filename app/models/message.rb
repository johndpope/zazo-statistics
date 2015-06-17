class Message
  include ActiveModel::Model
  attr_accessor :id, :filename, :sender_id, :receiver_id,
                :date, :size, :status, :delivered, :events

  alias_method :delivered?, :delivered

  def events
    EventsApi.new.message_events(id).map { |e| Event.new(e) }
  end
end
