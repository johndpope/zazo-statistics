class StatusController < ApplicationController
  def new_users_today
    render json: User.where('created_at >= ?', Date.today.midnight).count
  end

  def new_verified_users_today
    render json: User.verified.where('created_at >= ?', Date.today.midnight).count
  end

  def heartbeat
    render json: { version: Settings.version }
  end
end
