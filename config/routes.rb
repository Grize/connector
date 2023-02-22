Rails.application.routes.draw do
  scope 'api' do
    scope 'priora' do
      use_doorkeeper scope: 'v2' do
        controllers tokens: 'api/priora/v2/tokens'
        skip_controllers :authorizations, :applications, :authorized_applications
      end
    end
  end
  devise_for :users, controllers: { sessions: 'users/sessions' }
end
