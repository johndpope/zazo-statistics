class Fetch::Users::IdsAndNames < Fetch::Base
  attr_accessor :users

  after_initialize :set_options

  validates :users, presence: true

  def execute
    User.where(mkey: users).each_with_object({}) do |user, memo|
      memo[user.mkey] = { id: user.id, name: user.name }
    end
  end

  private

  def set_options
    @users = options['users']
  end
end
