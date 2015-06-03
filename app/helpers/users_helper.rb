module UsersHelper
  def render_event(user, event)
    render 'event', user: user, event: event
  end

  def visualize_social_graph(user)
    query = UserVisualizationQuery.new user
    query.execute
    data = {
        user: (UserVisualizationSerializer.new query.user, root: false).as_json,
        friends: (query.friends.map { |u| UserVisualizationSerializer.new(u, root: false) }).as_json,
        connections: (query.connections.map { |u| ConnectionVisualizationSerializer.new(u, root: false) }).as_json
    }
    content_tag :div, '', id: 'visualization', data: data
  end
end