class UsersVisualizationSerializer < PackSerializer
  ATTRIBUTES = [:id, :name, :mobile_number, :status, :connection_counts,
                :messages_by_last_month, :average_messages_per_day]

private

  def member_connection_counts(user)
    user.respond_to?(:connection_counts) ? user.connection_counts : 0
  end

  def member_status(user)
    get_total_or_average_messages(user, :total) > 0 ? 'active' : user.status
  end

  def member_messages_by_last_month(user)
    get_total_or_average_messages user, :total
  end

  def member_average_messages_per_day(user)
    get_total_or_average_messages user, :average
  end

  def get_total_or_average_messages(user, key)
    @options && @options[:messages] &&
    @options[:messages][user.mkey]  &&
    @options[:messages][user.mkey][key] || 0
  end
end
