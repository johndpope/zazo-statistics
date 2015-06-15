class UserDecorator < Draper::Decorator
  delegate_all

  def connected_by_states
    initial = User::STATES.each_with_object({}) do |state, memo|
      memo[state] = []
    end
    @connected_by_state ||= object.connected_users.each_with_object(initial) do |user, memo|
      memo[user.status.to_sym] << user
    end
  end

  def connected_counts_by_states
    User::STATES.inject('') do |memo, state|
      memo += "#{state} [#{connected_by_states[state].size}] "
    end
  end

  def connected_counts
    User::STATES.inject(0) do |memo, state|
      memo += connected_by_states[state].size
    end
  end
end
