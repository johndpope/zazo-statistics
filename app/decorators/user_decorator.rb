class UserDecorator < Draper::Decorator
  delegate_all

  #
  # Connected users
  #

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
      memo + "#{state} [#{connected_by_states[state].size}] "
    end
  end

  def connected_counts
    User::STATES.inject(0) do |memo, state|
      memo + connected_by_states[state].size
    end
  end

  #
  # Connections
  #

  def grouped_connections(merge = true)
    unless @grouped_connections
      initial = { active: [], inactive: [] }
      @grouped_connections = object.connections.each_with_object(initial) do |conn, memo|
        conn.active? ? memo[:active] << conn.decorate : memo[:inactive] << conn.decorate
      end
    end

    if merge
      sort_connections(@grouped_connections[:active]) +
        sort_connections(@grouped_connections[:inactive])
    else
      @grouped_connections
    end
  end

  def connections_counts_by_groups
    active = grouped_connections(false)[:active].size
    invitees, inviters = 0, 0
    grouped_connections.each do |conn|
      conn.creator.id == object.id ? invitees += 1 : inviters += 1
    end
    "active [#{active}] invited by user [#{invitees}] invited by friend [#{inviters}]"
  end

  def connections_counts
    grouped_connections.size
  end

  private

  def sort_connections(conns)
    conns.sort_by { |c| c.creator.id == object.id ? 1 : 0 }
  end
end
