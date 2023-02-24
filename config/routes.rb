Rails.application.routes.draw do
  namespace 'api' do
    namespace 'priora' do
      namespace 'v2' do
        post :tokens, to: 'tokens#create'
        resources :authorizations, only: [:new, :create]
        post 'ais/refresh', to: 'ais#update'
      end
    end
  end
  devise_for :users
end
