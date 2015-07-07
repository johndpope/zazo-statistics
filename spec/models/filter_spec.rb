require 'rails_helper'

RSpec.describe Filter, type: :model do
  describe '.find' do
    subject { described_class.find filter }

    context 'unknown' do
      let(:filter) { :unknown }
      specify do
        expect { subject }.to raise_error('Filter :unknown not found')
      end
    end

    context 'messages_sent' do
      let(:filter) { :not_verified }
      it { is_expected.to eq(Filter::NotVerified) }
    end
  end
end
