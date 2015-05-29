class UserVisualizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :mobile_number, :status

  has_many :connections, serializer: ConnectionVisualizationSerializer

  def connections
    Connection.for_user_id(object.id).joins(:creator).joins(:target)
  end
end