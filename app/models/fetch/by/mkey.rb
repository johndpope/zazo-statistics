class Fetch::By::Mkey < Fetch::Base
  def execute
    users = User.where mkey: @options['users']
    users.each_with_object({}) do |user, memo|
      memo[user.mkey] = user.name
    end
  end
end
