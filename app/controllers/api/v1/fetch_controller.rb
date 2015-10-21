class Api::V1::FetchController < ApiController
  def show
    render json: Fetch.new(params[:prefix], params[:name], options).do
  rescue Fetch::InvalidOptions => error
    render json: { errors: error.message }, status: :unprocessable_entity
  rescue Fetch::UnknownClass => error
    render json: { errors: error.message }, status: :not_found
  end

  private

  def options
    params.except(:controller, :action, :name, :prefix)
  end
end
