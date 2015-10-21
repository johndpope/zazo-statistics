require 'rails_helper'

RSpec.describe Fetch::Users::NotVerified, type: :model do
  let(:instance) { described_class.new }

  let!(:conn) { FactoryGirl.create :connection }

  describe '#execute' do
    subject { instance.execute }

    it do
      result = {
        'id'            => conn.target.id,
        'mkey'          => conn.target.mkey,
        'connection_id' => conn.id,
        'time_zero'     => conn.created_at.to_s,
        'invitee'       => conn.target.name,
        'inviter'       => conn.creator.name
      }
      is_expected.to include result
    end
  end
end
