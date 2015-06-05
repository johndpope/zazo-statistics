require 'rails_helper'

RSpec.describe EmberController, type: :controller, authenticate_with_http_basic: true do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
