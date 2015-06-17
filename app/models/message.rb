class Message
  include ActiveModel::Model
  attr_accessor :id, :sender_id, :receiver_id, :uploaded_at,
                :file_name, :file_size, :status, :delivered, :events

  alias_method :delivered?, :delivered
  alias_method :to_s, :file_name

  def events
    EventsApi.new.message_events(id).map { |e| Event.new(e) }
  end
end
