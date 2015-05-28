require 'rails_helper'

RSpec.describe MetricsController, type: :controller, authenticate_with_http_basic: true do
  describe 'GET #index' do
    subject { get :index }

    it 'calls EventsApi#metric_list' do
      expect_any_instance_of(EventsApi).to receive(:metric_list)
      subject
    end

    it 'renders only grouppable_by_timeframe metrics' do
      VCR.use_cassette('events/metrics/index', erb: {
                         base_url: Figaro.env.events_api_base_url }) do
        subject
        expect(assigns(:metrics)).to all(be_aggregated_by_timeframe)
      end
    end

    it 'returns http success' do
      allow_any_instance_of(EventsApi).to receive(:metric_list)
      subject
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    subject { get :show, id: metric, group_by: group_by }

    context 'messages_sent' do
      let(:metric) { :messages_sent }

      context 'by day' do
        let(:group_by) { :day }

        it 'calls EventsApi#metric_data' do
          expect_any_instance_of(EventsApi).to receive(:metric_data)
          subject
        end

        it 'returns http success' do
          allow_any_instance_of(EventsApi).to receive(:metric_data).and_return({})
          subject
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
