class Fetch::Users::NotVerified < Fetch::Base
  def execute
    strip_data query
  end

  private

  def query
    sql = <<-SQL
      SELECT
        users.id,
        users.mkey,
        max_time_zero.connection_id,
        max_time_zero.time_zero,
        CONCAT(users.first_name, ' ', users.last_name) invitee,
        CONCAT(inviters.first_name, ' ', inviters.last_name) inviter
      FROM users
        INNER JOIN (
          SELECT
            users.mkey,
            MAX(connections.id) connection_id,
            MAX(connections.created_at) time_zero
          FROM users
            INNER JOIN connections ON users.id = connections.target_id
          WHERE users.status NOT IN ('registered', 'verified')
          GROUP BY users.mkey
        ) AS max_time_zero ON max_time_zero.mkey = users.mkey
        INNER JOIN connections ON connections.target_id = users.id AND
                                  connections.created_at = max_time_zero.time_zero
        INNER JOIN users inviters ON inviters.id = connections.creator_id
    SQL
    User.connection.select_all sql
  end
end
