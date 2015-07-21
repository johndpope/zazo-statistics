class Fetch::Users::Names < Fetch::Base
  attr_accessor :users

  after_initialize :set_options

  validates :users, presence: true

  def execute
    User.where(mkey: users).each_with_object({}) do |user, memo|
      memo[user.mkey] = user.name
    end
  end

  def set_options
    @users = options['users']
  end
end
