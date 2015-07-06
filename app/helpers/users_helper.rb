module UsersHelper
  def render_event(user, event)
    render 'event', user: user, event: event
  end

  def visualize_social_graph(user, settings = {})
    query = UserVisualizationDataQuery.new user, settings
    query.execute
    data = {
      target:      (query.target).as_json,
      users:       (query.users).as_json,
      connections: (query.connections).as_json,
      settings:    (query.settings).as_json
    }
    content_tag :div, '', id: 'visualization', data: data
  end

  def part_and_percentage(total, part)
    number = total.zero? ? 0 : part * 100.0 / total
    percent = number_to_percentage(number, precision: 2)
    "#{part} (#{percent})"
  end
end
