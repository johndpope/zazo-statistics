class UserVisualizationQuery
  attr_accessor :target, :connections, :users

  def initialize(user)
    @target = user
  end

  def execute
    @connections = Connection.for_user_id(target.id).includes(:creator).includes(:target)
    @users = users_with_connection_counts
  end

private

  def get_users_ids
    @connections.each_with_object([]) do |conn, memo|
      memo << conn.target_id  if target.id != conn.target_id
      memo << conn.creator_id if target.id != conn.creator_id
    end.uniq + [@target.id]
  end

  def users_with_connection_counts
    query = <<-SQL
      SELECT users.*, COUNT(connections.id) AS connection_counts
      FROM users
      INNER JOIN connections ON
        users.id = connections.target_id OR
        users.id = connections.creator_id
      WHERE users.id IN ?
      GROUP BY users.id
    SQL
    User.find_by_sql [query, get_users_ids]
  end
end