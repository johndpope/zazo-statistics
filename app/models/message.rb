class Message
  include ActiveModel::Model
  attr_accessor :id, :filename, :sender_id, :receiver_id,
                :date, :size, :status, :delivered

  alias_method :delivered?, :delivered
end
