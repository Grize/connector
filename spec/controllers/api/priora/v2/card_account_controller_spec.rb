require 'rails_helper'

RSpec.describe Api::Priora::V2::CardAccountsController, type: :controller do
  let(:user) { create(:user) }
  let(:application) { create(:application) }
  let!(:balance1) { create(:balance, account_id: account.id) }
  let!(:balance2) { create(:balance, account_id: account.id) }

  let(:account_data) do
    {
      pan: Faker::Bank.account_number,
      credit_limit: {
        currency: 'EUR',
        amount: '10000'
      },
      extra: {
        usage: 'PRIV',
        details: 'string'
      }
    }
  end

  let!(:account) do
    create(:account, user_id: user.id, account_type: 'card_account', data: account_data)
  end

  let!(:token) do
    create(:token, application_id: application.id, user_id: user.id, status: 'active')
  end

  let(:signature) do
    key = OpenSSL::PKey::RSA.new(File.read('./spec/test_certificates/salt_edge_private.pem'))
    "Bearer #{encode(params, key)}"
  end

  let(:headers) { { 'Access-Token': token.token, Authorization: signature } }

  describe 'GET index' do
    let(:params) do
      {
        data: {
          session_secret: 'cziaTXgBaCYerEHDvWE9'
        },
        exp: 2.day.from_now.to_i
      }
    end

    it 'return account list' do
      request.headers.merge!(headers)
      get :index
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body['data'].count).to eq(1)
      expect(body['data'].first['balances'].count).to eq(2)
      expect(body['data'].first['currency']).to eq('USD')
    end
  end

  describe 'GET show' do
    let!(:transaction) do
      create(:transaction, account_id: account.id,
                           data: transaction_data,
                           transaction_type: 'card')
    end

    let(:transaction_data) do
      {
        terminal_id: 'example-of-terminal-id',
        original_amount:  {
          currency: 'USD',
          amount: '12300'
        },
        markup_fee: {
          currency: 'USD',
          amount: '123'
        },
        markup_fee_percentage: {
          currency: 'USD',
          amount: '123'
        },
        card_acceptor_id: 'example-of-acceptor-id',
        card_acceptor_address: {
          street: 'rue blue',
          building_number: '89',
          city: 'Paris',
          postal_code: '75000',
          country: 'FR'
        },
        merchant_category_code: 'example-of-merchant-category-code',
        masked_pan: '525412******3241',
        transaction_details: 'Example of details',
        invoiced: true,
        proprietary_bank_transaction_code: 'example-code'
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
