require 'rails_helper'

RSpec.describe Fetch::PushUser, type: :model do
  let(:push_user) { FactoryGirl.create :push_user }
  let(:instance)  { Fetch.new nil, :push_user, options }

  describe '#execute' do
    let(:options) { { mkey: push_user.mkey } }
    subject { instance.do }

    it do
      expected = {
        mkey:            push_user.mkey,
        push_token:      push_user.push_token,
        device_platform: push_user.device_platform,
        device_build:    push_user.device_build
      }
      is_expected.to eq expected
    end
  end

  describe 'validations' do
    context 'with correct mkey' do
      let(:options) { { mkey: push_user.mkey } }

      it { expect { instance.do }.to_not raise_error }
    end

    context 'without mkey' do
      let(:options) { Hash.new }

      it { expect { instance.do }.to raise_error(Fetch::InvalidOptions, '{:mkey=>["can\'t be blank"]}') }
    end

    context 'with invalid mkey' do
      let(:options) { { mkey: 'xxxxxxxxxxxx' } }

      it { expect { instance.do }.to raise_error(Fetch::InvalidOptions, '{:push_user=>["mkey is not correct"]}') }
    end
  end
end
