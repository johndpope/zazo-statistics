class Fetch::Users::GetZazoFriends < Fetch::Base
  attr_accessor :user_mkey

  after_initialize :set_options

  def execute
    mkeys = Set.new
    connections.each do |conn|
      mkeys.merge [conn.target.mkey, conn.creator.mkey]
    end
    mkeys.delete user_mkey
    mkeys.to_a
  end

  private

  def connections
    user = User.find_by_mkey user_mkey
    user ? user.connections.includes(:target, :creator) : []
  end

  def set_options
    @user_mkey  = options['user_mkey']
  end
end
