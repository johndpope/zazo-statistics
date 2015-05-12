class DashboardController < AdminController
  def index
  end

  def messages_sent
    render json: events_api.messages_sent
  end

  private

  def events_api
    EventsApi.new
  end
end
