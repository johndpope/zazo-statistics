class AdminController < ApplicationController
  http_basic_authenticate_with name: Figaro.env.http_basic_username, password: Figaro.env.http_basic_password

  def events_api
    EventsApi.new
  end
end
