require 'rails_helper'

RSpec.describe Fetch::Users::RecentlyJoined, type: :model do
  let(:instance) { described_class.new params }

  describe '#execute' do
    subject { instance.execute }

    def only_user_ids(users)
      users.map { |u| u[:id] }
    end

    context 'with specific time_frame_in_days' do
      let(:params) { { time_frame_in_days: '5' } }
      let!(:user_1) { Timecop.travel(6.days.ago) { FactoryGirl.create(:user) } }
      let!(:user_2) { Timecop.travel(3.days.ago) { FactoryGirl.create(:user) } }
      let!(:user_3) { Timecop.travel(1.days.ago) { FactoryGirl.create(:user) } }

      it { expect(only_user_ids(subject)).to eq [user_2.id, user_3.id] }
    end

    context 'without specific time_frame_in_days' do
      let(:params) { {} }
      let!(:user_1) { Timecop.travel(10.months.ago) { FactoryGirl.create(:user) } }
      let!(:user_2) { Timecop.travel(6.months.ago)  { FactoryGirl.create(:user) } }
      let!(:user_3) { Timecop.travel(3.months.ago)  { FactoryGirl.create(:user) } }

      it { expect(only_user_ids(subject)).to eq [user_1.id, user_2.id, user_3.id] }
    end
  end
end
