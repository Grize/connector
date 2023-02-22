require 'rails_helper'

RSpec.describe Api::Priora::V2::TokensController, type: :controller do
  describe 'POST create' do
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
          app_name: 'Example Name'
        },
        exp: 2.days.from_now.to_i
      }
    end

    let(:auth_signature) do
      "Bearer #{Support::JwtTestMixin.new.encode(payload, 'salt_edge_private')}"
    end

    let(:salt_edge_payload) do
      {
        data: {
          session_secret: 'b7k-QxC3vdA-M48pexiS',
          redirect_url: 'http://test.host/users/sign_in'
        },
        exp: 2.day.from_now.to_i
      }
    end

    let(:request_signature) do
      "Bearer #{Support::JwtTestMixin.new.encode(salt_edge_payload, 'app_private')}"
    end

    before do
      headers = {
        'Authorization': request_signature,
        'App-Id': 'some_id',
        'App-Secret': 'some_secret'
      }

      stub_request(:patch, 'http://salt_edge.demo/api/connectors/v2/sessions/b7k-QxC3vdA-M48pexiS/update')
        .with(headers: headers).to_return(status: 200)
    end

    it 'save token params and send request to salt_edge' do
      request.headers['Authorization'] = auth_signature
      post :create
      expect(response.status).to eq(200)
      token_data = JSON.parse(REDIS_CLIENT.get('b7k-QxC3vdA-M48pexiS'))
      expect(token_data['app_name']).to eq('Example Name')
    end
  end
end
