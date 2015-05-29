module UsersHelper
  def render_event(user, event)
    render 'event', user: user, event: event
  end

  def visualize_social_graph(options = {})
    if options[:limit].nil?
      users = User.all
    else
      users = User.limit options[:limit].to_i
    end
    data = (users.map { |u| UserVisualizationSerializer.new(u) }).as_json
    content_tag :div, '', id: 'visualization', data: { users: data }
  end
end