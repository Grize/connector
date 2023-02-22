Rails.application.routes.draw do
  namespace 'api' do
    namespace 'priora' do
      namespace 'v2' do
        resources :tokens, only: [:create]
      end
    end
  end
  use_doorkeeper
  devise_for :users, controllers: { sessions: 'users/sessions' }
end
