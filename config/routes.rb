Rails.application.routes.draw do
  mount Raddocs::App => '/docs'

  namespace :api do
    namespace :v1 do
      scope module: 'employees' do
        post 'authenticate', to: 'authentication#authenticate'
      end

      resources :courses, only: %i[create destroy]
      resources :users, only: %i[create destroy]
    end
  end
end
