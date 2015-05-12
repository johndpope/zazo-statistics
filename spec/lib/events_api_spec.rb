require 'rails_helper'

RSpec.describe EventsApi do
  let(:instance) { described_class.new }

  describe '#api_base_url' do
    subject { instance.api_base_url }
    it { is_expected.to eq(Figaro.env.events_api_base_url) }
  end

  describe '#connection' do
    subject { instance.connection }
    it { is_expected.to be_a(Faraday::Connection) }
  end

  describe '#messages_sent_path' do
    subject { instance.messages_sent_path }
    it { is_expected.to eq('api/v1/engagement/messages_sent') }
  end

  describe '#messages_sent' do
    subject { instance.messages_sent }
    specify do
      VCR.use_cassette('events_messages_sent', erb: {
                         base_url: Figaro.env.events_api_base_url
                       }) do
        is_expected.to eq(
          '2015-05-09 00:00:00 UTC' => 3,
          '2015-05-10 00:00:00 UTC' => 4,
          '2015-05-11 00:00:00 UTC' => 5,
          '2015-05-12 00:00:00 UTC' => 5)
      end
    end
  end
end
