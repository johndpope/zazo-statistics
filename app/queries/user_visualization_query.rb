class UserVisualizationQuery
  attr_accessor :user, :connections, :friends

  def initialize(user)
    @user = user
  end

  def execute
    @connections = Connection.for_user_id(user.id).includes(:creator).includes(:target)
    @friends = friends_with_connection_counts
  end

private

  def get_friends_ids
    @connections.each_with_object([]) do |conn, memo|
      memo << conn.target_id  if user.id != conn.target_id
      memo << conn.creator_id if user.id != conn.creator_id
    end.uniq
  end

  def friends_with_connection_counts
    query = <<-SQL
      SELECT users.*, COUNT(connections.id) AS connection_counts
      FROM users
      INNER JOIN connections ON
        users.id = connections.target_id OR
        users.id = connections.creator_id
      WHERE users.id IN ?
      GROUP BY users.id
    SQL
    User.find_by_sql [query, get_friends_ids]
  end
end