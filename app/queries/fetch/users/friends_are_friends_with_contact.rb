class Fetch::Users::FriendsAreFriendsWithContact < Fetch::Base
  attr_accessor :user_id, :contact_id

  after_initialize :set_options

  validates :user_id, :contact_id, presence: true

  def execute
    set = results.each_with_object(Set.new) do |res, set|
      set.merge [res['creator'], res['target']]
    end
    set.delete @contact_mkey
    set.to_a
  end

  private

  def results
    sql = <<-SQL
      SELECT
        by_creator.mkey creator,
        by_target.mkey target
      FROM connections
        JOIN users by_creator ON by_creator.id = creator_id
        JOIN users by_target ON by_target.id = target_id
      WHERE (creator_id IN (?) OR target_id IN (?)) AND
            (creator_id = ? OR target_id = ?)
    SQL
    sanitize_params = [sql, friends_ids, friends_ids, contact_id, contact_id]
    Connection.connection.select_all Connection.send(:sanitize_sql_array, sanitize_params)
  end

  def friends_ids
    return @friends_ids if @friends_ids
    connections = User.find(user_id).connections.includes(:target, :creator)
    set = connections.each_with_object(Set.new) do |conn, set|
      set.merge [conn.target_id, conn.creator_id]
    end
    set.delete user_id
    set.delete contact_id
    @friends_ids = set.to_a
  end

  def set_options
    @user_id    = User.find_by_mkey(options['user_mkey']).try(:id)
    @contact_id = User.find_by_mkey(options['contact_mkey']).try(:id)
    @contact_mkey = options['contact_mkey']
  end
end
