class Event
  include ActiveModel::Model
  include Draper::Decoratable

  attr_accessor :id, :name, :triggered_by, :triggered_at,
                :initiator, :initiator_id,
                :target, :target_id,
                :data, :raw_params, :message_id,
                :created_at, :updated_at
end
