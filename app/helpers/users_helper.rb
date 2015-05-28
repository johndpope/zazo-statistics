module UsersHelper
  def render_event(user, event)
    render 'event', user: user, event: event
  end
end
