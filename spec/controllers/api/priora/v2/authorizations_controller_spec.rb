require 'rails_helper'

RSpec.describe Api::Priora::V2::AuthorizationsController, type: :controller do
  let(:user) { create(:user) }
  let(:application) { create(:application) }
  let!(:token) { create(:token, applications_id: application.id) }

  describe 'GET new' do
    let(:application) { create(:application) }

    it 'return application record' do
      sign_in user
      get :new, params: { client_id: application.uid, redirect_uri: 'http://example.org' }
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    let(:salt_edge_payload) do
      {
        data: {
          session_secret: 'some_token',
          token: token.token,
          user_id: user.id,
          consent: {
            allPsd2: 'allAccounts'
          }
        },
        exp: 2.day.from_now.to_i
      }
    end

    let(:request_signature) do
      private_key = OpenSSL::PKey::RSA.new(File.read('./spec/test_certificates/app_private.pem'))
      "Bearer #{encode(salt_edge_payload, private_key)}"
    end

    let(:application) { create(:application) }

    before do
      stub_request(:any, 'https://priora.saltedge.com/api/connectors/v2/sessions/some_token/success')
    end

    it 'create token' do
      sign_in user
      post :create, params: { client_id: application.id, token_id: token.id }
      expect(WebMock).to have_requested(:patch, 'https://priora.saltedge.com/api/connectors/v2/sessions/some_token/success')
        .with(headers: { 'App-Id': 'some_id', 'App-Secret': 'some_secret', 'Authorization': request_signature})

      token.reload
      expect(token.status).to eq('active')
      expect(token.users_id).to eq(user.id)
    end
  end
end
