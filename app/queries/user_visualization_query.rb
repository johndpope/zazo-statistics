class UserVisualizationQuery
  attr_accessor :user, :connections, :friends

  def initialize(user)
    @user = user
  end

  def execute
    @connections = Connection.for_user_id(user.id).includes(:creator).includes(:target)
    @friends = User.where id: get_friends_ids
  end

private

  def get_friends_ids
    @connections.each_with_object([]) do |conn, memo|
      memo << conn.target_id  if user.id != conn.target_id
      memo << conn.creator_id if user.id != conn.creator_id
    end.uniq
  end
end