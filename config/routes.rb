Rails.application.routes.draw do
  namespace 'api' do
    namespace 'priora' do
      namespace 'v2' do
        post :tokens, to: 'tokens#create'
        resources :authorizations, only: %i[new create]
        post 'ais/refresh', to: 'ais#update'
        get :accounts, to: 'accounts#index'
        get 'accounts/:account_id/transactions', to: 'accounts#show'
        get :card_accounts, to: 'card_accounts#index'
        get 'card_accounts/:account_id/transactions', to: 'card_accounts#show'
      end
    end
  end
  devise_for :users
end
