require 'rails_helper'

RSpec.describe S3Credential, type: :model do
  let(:instance) { S3Credential.instance }

  context 'attributes' do
    subject { S3Credential.credential_attributes }
    it { is_expected.to match_array(%i(region access_key secret_key bucket)) }
  end

  context 'methods' do
    S3Credential.credential_attributes.each do |attr|
      it { is_expected.to respond_to(attr) }
      it { is_expected.to respond_to(:"#{attr}=") }
    end
  end

  context 'validations' do
    it { is_expected.to validate_inclusion_of(:region).in_array(%w(us-east-1 us-west-1 us-west-2 ap-southeast-1 ap-southeast-2 ap-northeast-1 sa-east-1)) }
  end

  describe 'methods' do
    before do
      instance.region = 'us-east-1'
      instance.bucket = 'bucket'
      instance.access_key = 'access_key'
      instance.secret_key = 'secret_key'
    end

    context '#id' do
      subject { instance.id }
      it { is_expected.to_not be_nil }
    end

    context '#cred_type' do
      subject { instance.cred_type }
      it { is_expected.to eq('s3') }
    end

    context '#region' do
      subject { instance.region }
      it { is_expected.to eq('us-east-1') }
    end

    context '#bucket' do
      subject { instance.bucket }
      it { is_expected.to eq('bucket') }
    end

    context '#access_key' do
      subject { instance.access_key }
      it { is_expected.to eq('access_key') }
    end

    context '#secret_key' do
      subject { instance.secret_key }
      it { is_expected.to eq('secret_key') }
    end

    context '#save' do
      subject { instance.save }
      it { is_expected.to be_truthy }
    end

    context 'loads attributes' do
      before do
        instance.update_credentials(region: 'us-east-1',
                                    bucket: 'bucket',
                                    access_key: 'access_key',
                                    secret_key: 'secret_key')
      end
      subject { S3Credential.instance }

      specify do
        is_expected.to have_attributes(region: 'us-east-1',
                                       bucket: 'bucket',
                                       access_key: 'access_key',
                                       secret_key: 'secret_key')
      end
    end

    describe '#s3_client' do
      subject { instance.s3_client }

      it { is_expected.to be_a(Aws::S3::Client) }

      context 'region' do
        subject { instance.s3_client.config.region }
        it { is_expected.to eq(instance.region) }
      end

      context 'access_key_id' do
        subject { instance.s3_client.config.access_key_id }
        it { is_expected.to eq(instance.access_key) }
      end

      context 'secret_access_key' do
        subject { instance.s3_client.config.secret_access_key }
        it { is_expected.to eq(instance.secret_key) }
      end
    end
  end
end
