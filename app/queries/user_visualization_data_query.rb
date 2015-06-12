class UserVisualizationDataQuery
  attr_reader :target, :connections, :users, :settings

  def initialize(user, settings = {})
    @user     = user
    @settings = {
      depth: settings.key?(:depth) ? settings[:depth].to_i : 1
    }
    @in_depth = ConnectionsAndUsersInDepthQuery.new user, @settings[:depth]
  end

  def execute
    @in_depth.execute
    @connections = serialized_connections
    @users       = serialized_users
    @target = @users.find { |u| u[:id] == @user.id }
  end

  private

  def serialized_users
    users    = UsersWithConnectionCountsQuery.new(@in_depth.stretched_users).execute
    users    = [target] if users.empty?
    messages = AverageMessagesByPeriodQuery.new(users).execute
    UsersVisualizationSerializer.new(users, messages: messages).serialize
  end

  def serialized_connections
    counts = []#MessagesCountBetweenUsersQuery.new(@in_depth.users).execute
    ConnectionsVisualizationSerializer.new(@in_depth.connections, counts: counts).serialize
  end
end
