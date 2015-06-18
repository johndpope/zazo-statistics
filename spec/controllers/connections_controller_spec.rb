require 'rails_helper'

RSpec.describe ConnectionsController, type: :controller, authenticate_with_http_basic: true do
  describe 'GET #show' do
    let(:connection) { create(:connection) }
    subject { get :show, id: connection.to_param }

    around do |example|
      VCR.use_cassette('events/metrics/aggregate_messaging_info/connection', erb: {
                         base_url: Figaro.env.events_api_base_url,
                         user_id: connection.creator.event_id,
                         friend_id: connection.target.event_id }) { example.run }
    end

    it 'calls EventsApi#metric_data with valid params' do
      expect_any_instance_of(EventsApi).to receive(:metric_data).with(:aggregate_messaging_info,
                                                                      user_id: connection.creator.event_id,
                                                                      friend_id: connection.target.event_id).and_call_original
      subject
    end

    it 'converts to Event instances' do
      subject
      expect(assigns(:aggregate_messaging_info)).to eq('outgoing' => {
                                                         'total_sent' => 0,
                                                         'total_received' => 0,
                                                         'undelivered_percent' => nil
                                                       },
                                                       'incoming' => {
                                                         'total_sent' => 0,
                                                         'total_received' => 0,
                                                         'undelivered_percent' => nil
                                                       })
    end
  end

  describe 'GET #messages' do
    pending 'TODO: implement'
  end
end
