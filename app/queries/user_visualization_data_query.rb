class UserVisualizationDataQuery
  attr_reader :target, :connections, :users

  def initialize(user, settings = {})
    @user     = user
    @settings = {
      depth: settings.has_key?(:depth) ? settings[:depth].to_i : 1
    }
    @in_depth = ConnectionsAndUsersInDepthQuery.new user, @settings[:depth]
  end

  def execute
    @in_depth.execute
    @connections = get_connections
    @users  = get_users
    @target = @users.find { |u| u[:id] == @user.id }
  end

  private

  def get_users
    users    = UsersWithConnectionCountsQuery.new(@in_depth.stretched_users).execute
    users    = [target] if users.empty?
    messages = AverageMessagesByPeriodQuery.new(users).execute
    UsersVisualizationSerializer.new(users, messages: messages).serialize
  end

  def get_connections
    #counts = MessagesCountBetweenUsersQuery.new(@user.mkey, get_users_ids(false, connections)).execute
    ConnectionsVisualizationSerializer.new(@in_depth.connections, counts: []).serialize
  end
end
