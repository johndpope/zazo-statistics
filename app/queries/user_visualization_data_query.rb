class UserVisualizationDataQuery
  attr_accessor :target, :connections, :users

  def initialize(user, settings = {})
    @user     = user
    @settings = {
      depth: settings[:depth] || 1
    }
  end

  def execute
    @connections = get_connections
    @users  = get_users
    @target = @users.find { |u| u[:id] == @user.id }
  end

  private

  def get_users
    users    = UsersWithConnectionCountsQuery.new(get_users_ids).execute
    users    = [target] if users.empty?
    messages = AverageMessagesByPeriodQuery.new(users).execute
    UsersVisualizationSerializer.new(users, messages: messages).serialize
  end

  def get_connections
    connections = Connection.for_user_id(@user.id).includes(:creator).includes(:target)
    counts = MessagesCountBetweenUsersQuery.new(@user.mkey, get_users_ids(false, connections)).execute
    ConnectionsVisualizationSerializer.new(connections, counts: counts).serialize
  end


  def get_users_ids(with_target = true, connections = nil)
    connections = @connections unless connections
    @users_ids ||= connections.each_with_object([]) do |conn, memo|
      memo << { id: conn.target_id,  mkey: conn.target.event_id }  if @user.id != conn.target_id
      memo << { id: conn.creator_id, mkey: conn.creator.event_id } if @user.id != conn.creator_id
    end.uniq
    with_target ? @users_ids + [{ id: @user.id, mkey: @user.mkey }] : @users_ids
  end
end
