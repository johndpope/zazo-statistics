class UserVisualizationQuery
  attr_accessor :user, :connections, :friends

  def initialize(user)
    @user = user
  end

  def execute
    @connections = Connection.for_user_id(user.id).joins(:creator).joins(:target)
    @friends = User.where id: get_friends_ids
  end

private

  def get_friends_ids
    friends_ids = []
    @connections.each do |conn|
      friends_ids << conn.target_id  if user.id != conn.target_id
      friends_ids << conn.creator_id if user.id != conn.creator_id
    end
    friends_ids.uniq
  end
end