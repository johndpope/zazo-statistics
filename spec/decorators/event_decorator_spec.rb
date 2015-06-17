require 'rails_helper'

RSpec.describe EventDecorator do
  let(:event) { Event.new(hash) }
  let(:instance) { described_class.new(event) }

  describe '#name_as_string' do
    subject { instance.name }

    context 'empty hash' do
      let(:hash) { {} }
      it { is_expected.to eq('') }
    end

    context 'with valid hash' do
      let(:hash) do
        {
          'id' => 13,
          'name' => [
            'video',
            's3',
            'uploaded'
          ],
          'triggered_at' => '2015-05-12T15=>47=>41.045Z',
          'triggered_by' => 'aws=>s3',
          'initiator' => 'user',
          'initiator_id' => 'RxDrzAIuF9mFw7Xx9NSM',
          'target' => 'video',
          'target_id' => 'RxDrzAIuF9mFw7Xx9NSM-6pqpuUZFp1zCXLykfTIx-98dba07c0113cc717d9fc5e5809bc998',
          'data' => nil,
          'raw_params' => nil,
          'created_at' => '2015-05-12T15=>47=>41.046Z',
          'updated_at' => '2015-05-12T15=>47=>41.046Z',
          'message_id' => 'd4977224-d097-4eea-9baa-a484734afccf'
        }
      end
      it { is_expected.to eq('video:s3:uploaded') }
    end
  end
end
