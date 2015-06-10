class UsersVisualizationSerializer
  ATTRIBUTES = [:id, :name, :mobile_number, :status, :connection_counts,
                :messages_by_last_month, :average_messages_per_day]

  def initialize(users, options)
    @users   = users
    @options = options
  end

  def serialize
    @users.map { |u| serialize_user u }
  end

private

  def serialize_user(user)
    ATTRIBUTES.each_with_object({}) do |attr, memo|
      memo[attr] = respond_to?("user_#{attr}", true) ?
          send("user_#{attr}", user) : user.send(attr)
    end
  end

  #
  # Custom and redefined attributes
  #

  def user_connection_counts(user)
    user.respond_to?(:connection_counts) ?
        user.connection_counts : 0
  end

  def user_status(user)
    get_total_or_average_messages(user, :total) > 0 ?
        'active' : user.status
  end

  def user_messages_by_last_month(user)
    get_total_or_average_messages user, :total
  end

  def user_average_messages_per_day(user)
    get_total_or_average_messages user, :average
  end

  #
  # Attributes helpers
  #

  def get_total_or_average_messages(user, key)
    @options && @options[:messages] &&
    @options[:messages][user.mkey]  &&
    @options[:messages][user.mkey][key] || 0
  end
end
