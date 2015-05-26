require 'rails_helper'

RSpec.describe Metric, type: :model do
  let(:instance) { described_class.new(hash) }

  describe '#grouppable_by_timeframe?' do
    subject { instance.grouppable_by_timeframe? }

    context 'empty hash' do
      let(:hash) { {} }
      it { is_expected.to be_falsey }
    end

    context 'with valid hash' do
      let(:hash) do
        { 'name' => 'Metric::ActiveUsers',
          'metric_name' => 'active_users',
          'type' => 'grouppable_by_timeframe' }
      end
      it { is_expected.to be_truthy }
    end
  end
end
