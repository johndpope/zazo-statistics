require 'rails_helper'

RSpec.describe Api::V1::FetchController, type: :controller do
  before  { routes.draw { get 'show' => 'api/v1/fetch#show' } }

  describe 'GET "filter/:id"' do
    subject { get :show, id: name, prefix: :filter }

    context 'unknown' do
      let(:name) { :unknown }

      specify do
        subject
        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq('error' => 'Filter::Unknown class not found')
      end
    end

    context 'not_verified' do
      let(:name) { :not_verified }

      specify do
        subject
        expect(response).to have_http_status(:success)
        expect(json_response).to be_a(Array)
      end
    end
  end
end
