class ConnectionVisualizationSerializer < ActiveModel::Serializer
  attributes :creator_id, :target_id
end