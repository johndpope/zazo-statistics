class StatusController < ApplicationController
  def new_users_today
    render json: User.where('created_at >= ?', Date.today.midnight).count
  end

  def heartbeat
    render json: { version: Settings.version }
  end
end
