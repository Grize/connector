require 'rails_helper'

RSpec.describe Api::Priora::V2::TokensController, type: :controller do
  describe 'POST create' do
    let(:application) { create(:application) }
    let(:payload) do
      {
        data: {
          provider_code: 'test_ttp',
          redirect_url: 'http://test_redirect_url',
          session_secret: 'b7k-QxC3vdA-M48pexiS',
          recurring_indicator: true,
          access: {
            allPsd2: 'allAccounts'
          },
          valid_until: '2020-08-05',
          authorization_type: 'oauth',
          app_name: application.name
        },
        exp: 2.days.from_now.to_i
      }
    end

    let(:auth_signature) do
      private_key = OpenSSL::PKey::RSA.new(File.read('./spec/test_certificates/salt_edge_private.pem'))
      "Bearer #{encode(payload, private_key)}"
    end

    let(:salt_edge_payload) do
      redirect_uri = 'http://test.host/api/priora/v2/authorizations?'\
                     "client_id=#{application.uid}&token=blTC91cT8cvXWpjWq8yy8w"
      {
        data: {
          session_secret: 'b7k-QxC3vdA-M48pexiS',
          redirect_url: redirect_uri
        },
        exp: 2.day.from_now.to_i
      }
    end

    let(:request_signature) do
      private_key = OpenSSL::PKey::RSA.new(File.read('./spec/test_certificates/app_private.pem'))
      "Bearer #{encode(salt_edge_payload, private_key)}"
    end

    before do
      stub_request(:any, 'https://priora.saltedge.com/api/connectors/v2/sessions/b7k-QxC3vdA-M48pexiS/update')
      allow(SecureRandom).to receive(:urlsafe_base64).and_return('blTC91cT8cvXWpjWq8yy8w')
    end

    it 'save token params and send request to salt_edge' do
      request.headers['Authorization'] = auth_signature
      post :create
      expect(WebMock).to have_requested(:patch, 'https://priora.saltedge.com/api/connectors/v2/sessions/b7k-QxC3vdA-M48pexiS/update')
        .with(headers: { 'App-Id': 'some_id', 'App-Secret': 'some_secret', 'Authorization': request_signature})

      expect(Token.count).to eq(1)
      expect(Token.first.external_token).to eq('b7k-QxC3vdA-M48pexiS')
    end
  end
end
