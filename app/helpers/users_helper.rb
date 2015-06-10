module UsersHelper
  def render_event(user, event)
    render 'event', user: user, event: event
  end

  def visualize_social_graph(user)
    query = UserVisualizationDataQuery.new user
    query.execute
    data = {
        target:      (query.target).as_json,
        users:       (query.users).as_json,
        connections: (query.connections).as_json
    }
    content_tag :div, '', id: 'visualization', data: data
  end
end
