class Fetch::Users::ConnectionIds < Fetch::Base
  attr_accessor :users, :friends # mkeys

  after_initialize :set_options

  validates :users, :friends, presence: true

  def execute
    sql = <<-SQL
      SELECT
        CONCAT(users.mkey, '-', friends.mkey) relation,
        connections.id connection_id,
        users.mkey user_mkey,
        friends.mkey friend_mkey,
        users.id user_id,
        friends.id friend_id
      FROM
        connections,
        (SELECT id, mkey FROM users WHERE mkey IN (?)) users,
        (SELECT id, mkey FROM users WHERE mkey IN (?)) friends
      WHERE (connections.creator_id = users.id AND connections.target_id = friends.id) OR
            (connections.creator_id = friends.id AND connections.target_id = users.id)
    SQL
    sql = User.send :sanitize_sql_array, [sql, users, friends]
    User.connection.select_all sql
  end

  private

  def set_options
    @users   = options['users']
    @friends = options['friends']
  end
end
