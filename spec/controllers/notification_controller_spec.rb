require 'rails_helper'

RSpec.describe NotificationController, type: :controller do
  let(:video_id) { (Time.now.to_f * 1000).to_i.to_s }
  let(:user) { create(:user) }
  let(:target) do
    create(:push_user,
           mkey: user.mkey,
           device_platform: user.device_platform)
  end
  let(:push_user_params) do
    { mkey: user.mkey,
      push_token: 'push_token',
      device_platform: user.device_platform,
      device_build: :dev }
  end

  describe 'POST #set_push_token' do
    let(:params) { push_user_params }
    before do
      authenticate_with_http_digest(user.mkey, user.auth) do
        post :set_push_token, params
      end
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #send_video_received' do
    let(:params) do
      push_user_params.merge(from_mkey: user.mkey,
                             target_mkey: target.mkey,
                             video_id: video_id)
    end

    context 'target_mkey not given' do
      let(:params) { {} }
      specify do
        expect do
          authenticate_with_http_digest(user.mkey, user.auth) do
            post :send_video_status_update, params
          end
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context 'Android' do
      let(:user) { create(:android_user) }
      let(:payload) do
        GcmServer.make_payload(
          params[:push_token],
          type: 'video_received',
          from_mkey: params[:from_mkey],
          video_id: params[:video_id])
      end

      specify 'expects GenericPushNotification to receive :send_notification' do
        expect(GenericPushNotification).to receive(:send_notification)
        authenticate_with_http_digest(user.mkey, user.auth) do
          VCR.use_cassette('gcm_send_with_error', erb: {
                             key: Figaro.env.gcm_api_key, payload: payload }) do
            post :send_video_received, params
          end
        end
      end

      context 'response' do
        before do
          authenticate_with_http_digest(user.mkey, user.auth) do
            VCR.use_cassette('gcm_send_with_error', erb: {
                               key: Figaro.env.gcm_api_key, payload: payload }) do
              post :send_video_received, params
            end
          end
        end

        it { expect(response).to have_http_status(:success) }
        it { expect(JSON.parse(response.body)).to eq('status' => '200') }
      end
    end

    context 'iOS' do
      let(:user) { create(:ios_user) }

      specify 'expects GenericPushNotification to receive :send_notification' do
        expect(GenericPushNotification).to receive(:send_notification)
        authenticate_with_http_digest(user.mkey, user.auth) do
          post :send_video_received, params
        end
      end

      context 'response' do
        before do
          authenticate_with_http_digest(user.mkey, user.auth) do
            post :send_video_received, params
          end
        end

        it { expect(response).to have_http_status(:success) }
        it { expect(JSON.parse(response.body)).to eq('status' => '200') }
      end
    end
  end

  describe 'POST #send_video_status_update' do
    let(:params) do
      push_user_params.merge(to_mkey: user.mkey,
                             target_mkey: target.mkey,
                             video_id: video_id,
                             status: 'viewed')
    end

    context 'target_mkey not given' do
      let(:params) { {} }
      specify do
        expect do
          authenticate_with_http_digest(user.mkey, user.auth) do
            post :send_video_status_update, params
          end
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context 'Android' do
      let(:user) { create(:android_user) }
      let(:payload) do
        GcmServer.make_payload(
          params[:push_token],
          type: 'video_status_update',
          to_mkey: params[:to_mkey],
          status: params[:status],
          video_id: params[:video_id])
      end

      specify 'expects GenericPushNotification to receive :send_notification' do
        expect(GenericPushNotification).to receive(:send_notification)
        authenticate_with_http_digest(user.mkey, user.auth) do
          VCR.use_cassette('gcm_send_with_error', erb: {
                             key: Figaro.env.gcm_api_key, payload: payload }) do
            post :send_video_status_update, params
          end
        end
      end

      context 'response' do
        before do
          authenticate_with_http_digest(user.mkey, user.auth) do
            VCR.use_cassette('gcm_send_with_error', erb: {
                               key: Figaro.env.gcm_api_key, payload: payload }) do
              post :send_video_status_update, params
            end
          end
        end
        it { expect(response).to have_http_status(:success) }
        it { expect(JSON.parse(response.body)).to eq('status' => '200') }
      end
    end

    context 'iOS' do
      let(:user) { create(:ios_user) }

      specify 'expects GenericPushNotification to receive :send_notification' do
        expect(GenericPushNotification).to receive(:send_notification)
        authenticate_with_http_digest(user.mkey, user.auth) do
          post :send_video_status_update, params
        end
      end

      context 'response' do
        before do
          authenticate_with_http_digest(user.mkey, user.auth) do
            post :send_video_status_update, params
          end
        end
        it { expect(response).to have_http_status(:success) }
        it { expect(JSON.parse(response.body)).to eq('status' => '200') }
      end
    end
  end
end