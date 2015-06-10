class UserVisualizationDataQuery
  attr_accessor :target, :connections, :users

  def initialize(user)
    @target = user
  end

  def execute
    @connections = get_connections
    @users  = get_users
    @target = @users.find { |u| u[:id] == @target.id }
  end

private

  def get_users
    users    = UsersWithConnectionCountsQuery.new(get_users_ids).execute
    users    = [target] if users.empty?
    messages = AverageMessagesByPeriodQuery.new(users).execute
    UsersVisualizationSerializer.new(users, messages: messages).serialize
  end

  def get_connections
    Connection.for_user_id(target.id).includes(:creator).includes(:target)
  end

  def get_users_ids
    @connections.each_with_object([]) do |conn, memo|
      memo << conn.target_id  if target.id != conn.target_id
      memo << conn.creator_id if target.id != conn.creator_id
    end.uniq + [@target.id]
  end
end
