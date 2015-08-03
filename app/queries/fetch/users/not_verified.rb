class Fetch::Users::NotVerified < Fetch::Base
  def execute
    strip_data query
  end

  private

  def query
    sql = <<-SQL
      SELECT
        main.id,
        main.mkey,
        MAX(connections.created_at) time_zero,
        CONCAT(main.first_name, ' ', main.last_name) invitee,
        CONCAT(sideline.first_name, ' ', sideline.last_name) inviter
      FROM users main
        INNER JOIN connections ON main.id = connections.target_id
        INNER JOIN users sideline ON sideline.id = connections.creator_id
      WHERE main.status NOT IN ('registered','verified')
      GROUP BY main.mkey
    SQL
    User.connection.select_all sql
  end
end
