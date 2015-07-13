require 'rails_helper'

RSpec.describe Fetch::Attributes, type: :model do
  let!(:conn)    { FactoryGirl.create :connection }
  let(:instance) { Fetch.new nil, :attributes, options }

  describe '#execute' do
    let :options do
      { user:  conn.target.mkey,
        attrs: [:mkey, :first_name, :status] }
    end
    subject { instance.do }

    specify do
      result = {
        mkey:       conn.target.mkey,
        first_name: conn.target.first_name,
        status:     conn.target.status
      }
      is_expected.to eq(result)
    end
  end

  describe 'validations' do
    let(:options) { Hash.new }

    specify do
      expect{ instance.do }.to raise_error(Fetch::InvalidOptions)
    end
  end
end
