require 'rails_helper'

RSpec.describe DashboardController, type: :controller, authenticate_with_http_basic: true do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #messages_sent' do
    let(:params) { { group_by: :day } }

    it 'calls EventsApi#metric_data with messages_sent, group_by: :day' do
      expect_any_instance_of(EventsApi).to receive(:metric_data).with(:messages_sent, group_by: :day)
      get :messages_sent, params
    end

    it 'returns http success' do
      allow_any_instance_of(EventsApi).to receive(:metric_data).with(:messages_sent, group_by: :day)
      get :messages_sent, params
      expect(response).to have_http_status(:success)
    end
  end
end
