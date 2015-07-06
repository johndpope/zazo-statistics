class Message
  include ActiveModel::Model
  include Draper::Decoratable
  attr_accessor :id, :sender_id, :receiver_id, :uploaded_at,
                :file_name, :file_size, :status, :delivered, :events,
                :complete, :viewed, :missing_events

  alias_method :delivered?, :delivered
  alias_method :complete?, :complete
  alias_method :viewed?, :viewed
  alias_method :to_s, :file_name

  def events
    EventsApi.new.message_events(id).map { |e| Event.new(e) }
  end

  def incomplete?
    !complete?
  end

  def unviewed?
    !viewed?
  end

  def sender_id
    @sender_id ||= file_name.split('-').first
  end

  def receiver_id
    @receiver_id ||= file_name.split('-').second
  end
end
