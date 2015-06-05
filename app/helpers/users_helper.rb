module UsersHelper
  def render_event(user, event)
    render 'event', user: user, event: event
  end

  def visualize_social_graph(user)
    query = UserVisualizationQuery.new user
    query.execute
    data = {
        target: (UserVisualizationSerializer.new query.target, root: false).as_json,
        users: (query.users.map { |u| UserVisualizationSerializer.new(u, root: false) }).as_json,
        connections: (query.connections.map { |u| ConnectionVisualizationSerializer.new(u, root: false) }).as_json
    }
    content_tag :div, '', id: 'visualization', data: data
  end
end