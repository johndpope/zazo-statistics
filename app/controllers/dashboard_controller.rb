class DashboardController < AdminController
  def index
  end

  def users_created
    render json: User.group_by_day(:created_at).count
  end

  def users_device_platform
    render json: User.group(:device_platform).count
  end

  def users_status
    render json: User.group(:status).count
  end

  def messages_sent
    render json: events_api.messages_sent
  end

  private

  def events_api
    EventsApi.new
  end
end
