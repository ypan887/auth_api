Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', defaults: { format: :json }, at: 'auth', controllers: {
    omniauth_callbacks:  'overrides/omniauth_callbacks',
    sessions:            'overrides/sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show]
    end
  end

  root to: "api/v1/users#index"
end
