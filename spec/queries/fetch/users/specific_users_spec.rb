require 'rails_helper'

RSpec.describe Fetch::Users::SpecificUsers, type: :model do
  let(:instance) { described_class.new users: users }

  let!(:conn_1) { FactoryGirl.create :connection }
  let!(:conn_2) { FactoryGirl.create :connection }

  describe '#execute' do
    let(:users) do
      [ conn_1.target.mkey,
        conn_2.target.mkey,
        'xxxxxxxxxxxxxxxxxxxx' ]
    end
    subject { instance.execute }

    specify do
      results = [
        {
          'id'        => conn_1.target.id,
          'mkey'      => conn_1.target.mkey,
          'time_zero' => conn_1.created_at.to_s,
          'invitee'   => conn_1.target.name,
          'inviter'   => conn_1.creator.name
        },{
          'id'        => conn_2.target.id,
          'mkey'      => conn_2.target.mkey,
          'time_zero' => conn_2.created_at.to_s,
          'invitee'   => conn_2.target.name,
          'inviter'   => conn_2.creator.name
        }
      ]
      is_expected.to include(*results)
    end
  end
end
