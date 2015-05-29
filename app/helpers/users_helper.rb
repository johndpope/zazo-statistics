module UsersHelper
  def render_event(user, event)
    render 'event', user: user, event: event
  end

  def visualize_social_graph
    data = (User.limit(20).map { |u| UserVisualizationSerializer.new(u) }).as_json
    content_tag :div, '', id: 'visualization', data: { users: data }
  end
end