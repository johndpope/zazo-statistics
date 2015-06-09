class UserVisualizationDataQuery
  attr_accessor :target, :connections, :users

  def initialize(user)
    @target = user
  end

  def execute
    @connections = Connection.for_user_id(target.id).includes(:creator).includes(:target)
    @users = UsersWithConnectionCountsQuery get_users_ids
    @users = [target] if @users.empty?
    puts AverageMessagesByPeriodQuery.new(@users).execute
  end

private

  def get_users_ids
    @users_ids ||= @connections.each_with_object([]) do |conn, memo|
      memo << conn.target_id  if target.id != conn.target_id
      memo << conn.creator_id if target.id != conn.creator_id
    end.uniq + [@target.id]
  end
end
