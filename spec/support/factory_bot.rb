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
  end
end
