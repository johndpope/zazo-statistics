class ConnectionVisualizationSerializer < ActiveModel::Serializer
  attributes :creator_id, :target_id, :outgoing_count, :incoming_count

  def outgoing_count
    get_connection_info['outgoing']['total_received']
  end

  def incoming_count
    get_connection_info['incoming']['total_received']
  end

private

  def get_connection_info
    @aggregate_messaging_info ||= EventsApi.new.metric_data :aggregate_messaging_info,
                                                            user_id:   object.creator.event_id,
                                                            friend_id: object.target.event_id
  end
end
