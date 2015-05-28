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

  describe '#metric_list_path' do
    subject { instance.metric_list_path }
    it { is_expected.to eq('api/v1/metrics') }
  end

  describe '#metric_list' do
    subject { instance.metric_list }

    specify do
      VCR.use_cassette('events/metrics/index', erb: {
                         base_url: Figaro.env.events_api_base_url }) do
        is_expected.to eq([{ 'name' => 'Metric::ActiveUsers',
                             'metric_name' => 'active_users',
                             'type' => 'grouppable_by_timeframe' },
                           { 'name' => 'Metric::MessagesSent',
                             'metric_name' => 'messages_sent',
                             'type' => 'grouppable_by_timeframe' },
                           { 'name' => 'Metric::UsageByActiveUsers',
                             'metric_name' => 'usage_by_active_users',
                             'type' => 'grouppable_by_timeframe' },
                           { 'name' => 'Metric::UserActivity',
                             'metric_name' => 'user_activity',
                             'type' => 'metric' }])
      end
    end
  end

  describe '#metric_path' do
    subject { instance.metric_path(metric) }
    context 'messages_sent' do
      let(:metric) { :messages_sent }
      it { is_expected.to eq('api/v1/metrics/messages_sent') }
    end
  end

  describe '#metric_data' do
    subject { instance.metric_data(metric, options) }

    describe 'messages_sent' do
      let(:metric) { :messages_sent }
      let(:options) {}

      context 'group by day' do
        let(:options) { { group_by: :day } }
        around do |example|
          VCR.use_cassette('events/metrics/messages_sent/by_day', erb: {
                             base_url: Figaro.env.events_api_base_url }) { example.run }
        end

        specify do
          is_expected.to eq(
            '2015-05-09 00:00:00 UTC' => 3,
            '2015-05-10 00:00:00 UTC' => 4,
            '2015-05-11 00:00:00 UTC' => 5,
            '2015-05-12 00:00:00 UTC' => 5)
        end
      end

      context 'group by week' do
        let(:options) { { group_by: :week } }
        around do |example|
          VCR.use_cassette('events/metrics/messages_sent/by_week', erb: {
                             base_url: Figaro.env.events_api_base_url }) { example.run }
        end

        specify do
          is_expected.to eq(
            '2015-05-04 00:00:00 UTC' => 7,
            '2015-05-11 00:00:00 UTC' => 10)
        end
      end

      context 'group by month' do
        let(:options) { { group_by: :month } }
        around do |example|
          VCR.use_cassette('events/metrics/messages_sent/by_month', erb: {
                             base_url: Figaro.env.events_api_base_url }) { example.run }
        end

        specify do
          is_expected.to eq('2015-05-01 00:00:00 UTC' => 17)
        end
      end
    end

    describe 'user_activity' do
      let(:metric) { :user_activity }
      let(:options) {}
      let(:user_id) { 'RxDrzAIuF9mFw7Xx9NSM' }

      context 'user_id' do
        let(:options) { { user_id: user_id } }
        around do |example|
          VCR.use_cassette('events/metrics/user_activity/with_user_id', erb: {
                             base_url: Figaro.env.events_api_base_url,
                             user_id: user_id }) { example.run }
        end

        it { is_expected.to be_a(Array) }
      end

      context 'user_activity is empty' do
        around do |example|
          VCR.use_cassette('events/metrics/user_activity/without_user_id', erb: {
                             base_url: Figaro.env.events_api_base_url }) { example.run }
        end

        specify do
          expect { subject }.to raise_error(Faraday::ClientError)
        end
      end
    end
  end

  describe '#events_path' do
    subject { instance.events_path }

    it { is_expected.to eq('api/v1/events') }
  end

  describe '#by_token' do
    let(:tokens) { 'RxDrzAIuF9mFw7Xx9NSM' }
    subject { instance.by_tokens(tokens, options) }

    context 'reverse' do
      let(:options) { { reverse: true } }
      around do |example|
        VCR.use_cassette('events/index/by_tokens/reverse', erb: {
                           base_url: Figaro.env.events_api_base_url,
                           tokens: tokens }) { example.run }
      end

      it { is_expected.to be_a(Array) }
    end
  end
end
