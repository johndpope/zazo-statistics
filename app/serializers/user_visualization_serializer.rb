class UserVisualizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :mobile_number, :status, :connection_counts

  def connection_counts
    object.respond_to?(:connection_counts) ? object.connection_counts : 0
  end
end