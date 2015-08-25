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
    context 'without options' do
      let(:options) { Hash.new }

      specify do
        expect { instance.do }.to raise_error(Fetch::InvalidOptions)
      end
    end

    context 'with disallowed attrs' do
      let(:options) { { user: conn.target.mkey, attrs: [:destroy] } }

      specify do
        expect { instance.do }.to raise_error(Fetch::InvalidOptions, '{:attrs=>["attr destroy is not allowed"]}')
      end
    end
  end
end
