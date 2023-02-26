require 'rails_helper'

RSpec.describe Api::Priora::V2::AccountsController, type: :controller do
  let(:user) { create(:user) }
  let(:application) { create(:application) }
  let!(:account) { create(:account, user_id: user.id, account_type: 'account', data: account_data) }
  let!(:balance) { create(:balance, account_id: account.id) }

  let(:account_data) do
    {
      iban: Faker::Bank.iban,
      cash_type: 'TAXE',
      bban: '4215 4215 6421',
      bic: 'BARCGB22XXX',
      sort_code: '56-83-17',
      msisdn: '447912345678'
    }
  end

  let!(:token) do
    create(:token, application_id: application.id, user_id: user.id, status: 'active')
  end

  let(:signature) do
    key = OpenSSL::PKey::RSA.new(File.read('./spec/test_certificates/salt_edge_private.pem'))
    "Bearer #{encode(params, key)}"
  end

  describe 'GET index' do
    let(:params) do
      {
        data: {
          session_secret: 'cziaTXgBaCYerEHDvWE9'
        },
        exp: 2.day.from_now.to_i
      }
    end

    let(:headers) { { 'Access-Token': token.token, Authorization: signature } }

    it 'return account list' do
      request.headers.merge!(headers)
      get :index
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body['data'].count).to eq(1)
      expect(body['data'].first['balances'].count).to eq(1)
      expect(body['data'].first['currency']).to eq('USD')
    end
  end

  describe 'GET show' do
    let!(:transaction) do
      create(:transaction, account_id: account.id,
                           data: transaction_data,
                           transaction_type: 'account')
    end

    let(:transaction_data) do
      {
        creditor_details: {
          name:  Faker::Name.name,
          account: {
            iban: 'FK54RAND61068428514573',
            bban: '4210 3213 3211',
            currency: 'USD',
            masked_pan: '525412******3241',
            msisdn: '447912345678'
          }
        },
        debtor_details: {
          name: Faker::Name.name,
          account: {
            iban: 'FK54RAND610684285145421',
            bban: '4210 3213 3212',
            currency:  'USD',
            masked_pan: '525412******3241',
            msisdn: '447912345314'
          }
        },
        remittance_information: {
          structured: 'Example of remittance information structured',
          unstructured: 'Example of remittance information unstructured'
        },
        value_date: 2.days.from_now.iso8601
      }
    end

    let(:params) do
      {
        data: {
          account_id: account.id,
          from_date:  2.days.ago.iso8601,
          to_date: 2.days.from_now.iso8601,
          from_id: "12",
          session_secret: "yPsetCyP7cGznvb1fAFA"
        },
        exp: 2.day.from_now.to_i
      }
    end

    let(:headers) { { 'Access-Token': token.token, Authorization: signature } }

    it 'return transactions for account' do
      request.headers.merge!(headers)
      get :show, params: { account_id: account.id }
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body['data'].count).to eq(1)
      expect(body['data'].first['id']).to eq(transaction.id)
      expect(body['data'].first['currency']).to eq('USD')
    end
  end
end
