require 'rails_helper'

RSpec.describe Fetch::Users::ConnectionIds, type: :model do
  let(:instance) { described_class.new users: users, friends: friends }

  let!(:conn_1) { FactoryGirl.create :connection }
  let!(:conn_2) { FactoryGirl.create :connection }

  describe '#execute' do
    let(:users)   { [conn_1.target.mkey, conn_2.target.mkey] }
    let(:friends) { [conn_1.creator.mkey, conn_2.creator.mkey] }
    subject { instance.execute }

    it do
      results = [
        {
          'relation'      => "#{conn_1.target.mkey}-#{conn_1.creator.mkey}",
          'connection_id' => conn_1.id,
          'user_mkey'     => conn_1.target.mkey,
          'friend_mkey'   => conn_1.creator.mkey,
          'user_id'       => conn_1.target.id,
          'friend_id'     => conn_1.creator.id
        },{
          'relation'      => "#{conn_2.target.mkey}-#{conn_2.creator.mkey}",
          'connection_id' => conn_2.id,
          'user_mkey'     => conn_2.target.mkey,
          'friend_mkey'   => conn_2.creator.mkey,
          'user_id'       => conn_2.target.id,
          'friend_id'     => conn_2.creator.id
        }
      ]
      is_expected.to include *results
    end
  end
end
