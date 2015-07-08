class Api::V1::FetchController < ApplicationController
  def show
    render json: Fetch.new(params[:prefix], params[:name], options).do
  rescue Fetch::UnknownClass => error
    render json: { error: error.message }, status: :not_found
  end

  private

  def options
    params.except(:controller, :action, :name, :prefix)
  end
end
