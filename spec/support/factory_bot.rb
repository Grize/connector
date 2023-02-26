require 'factory_bot'

FactoryBot.define do
  factory :application do
    uid { Faker::Bank.iban }
    name { Faker::App.name }
    secret { Faker::Bank.iban }
  end

  factory :user do
    email { Faker::Internet.email }
    password { 123456 }
  end

  factory :token do
    id { '710b9358-a44e-47d4-baca-957d25dbb1ac' }
    token { SecureRandom.uuid }
    redirect_uri { 'https://example.com' }
    status { 'draft' }
    external_token { 'some_token' }
    expired_at { 2.days.from_now }
  end

  factory :account do
    name { Faker::Name.name }
    currency { 'USD' }
    status { 'enabled' }
    product_name { Faker::App.name }
  end

  factory :balance do
    balance_type { 'openingAvailable' }
    currency { 'USD' }
    amount { 100.0 }
  end

  factory :transaction do
    amount { 1000 }
    currency { 'USD' }
    status { 'enabled' }
    booking_date { 2.days.from_now.iso8601 }
    currency_exchange { [] }
  end
end
