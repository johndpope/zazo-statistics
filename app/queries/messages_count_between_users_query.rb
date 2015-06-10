class MessagesCountBetweenUsersQuery

  def initialize(user_mkey, friends_ids)
    @user_mkey   = user_mkey
    @friends_ids = friends_ids.map { |f| f[:mkey] }
  end

  def execute
    EventsApi.new.metric_data :messages_count_between_users,
                              user_id: @user_mkey,
                              friends_ids: @friends_ids
  end
end
