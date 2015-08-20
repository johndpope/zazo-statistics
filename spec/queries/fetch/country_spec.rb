require 'rails_helper'

RSpec.describe Fetch::Country, type: :model do
  let(:mobile)   { '+16502453537' }
  let(:user)     { FactoryGirl.create :user, mobile_number: mobile }
  let(:instance) { Fetch.new nil, :country, options }
  let(:options)  { { user: user.mkey } }

  describe '#execute' do
    subject { instance.do }
    [
      { phone: '+79109767407',  country: 'RU' },
      { phone: '+380919295770', country: 'UA' },
      { phone: '+16502453537',  country: 'US' }
    ].each do |row|
      context row.inspect do
        let(:mobile) { row[:phone] }
        it { is_expected.to eq row }
      end
    end
  end

  describe 'validations' do
    context 'without options' do
      let(:options) { Hash.new }
      it { expect { instance.do }.to raise_error(Fetch::InvalidOptions, '{:user=>["can\'t be blank"]}') }
    end

    context 'without incorrect user' do
      let(:options) { { user: 'xxxxxxxxxxxx' } }
      it { expect { instance.do }.to raise_error(Fetch::InvalidOptions, '{:user=>["can\'t be blank"]}') }
    end

    context 'with incorrect phone' do
      let(:mobile) { '123456789' }
      it { expect { instance.do }.to raise_error(Fetch::InvalidOptions, '{:phone=>["phone is incorrect"]}') }
    end
  end
end
