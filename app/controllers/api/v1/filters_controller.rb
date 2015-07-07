class Api::V1::FiltersController < ApplicationController
  def show
    render json: Filter.find(params[:id]).new.execute
  rescue Filter::UnknownFilter => error
    render json: { error: error.message }, status: :not_found
  end
end
