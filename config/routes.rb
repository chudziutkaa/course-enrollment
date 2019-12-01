Rails.application.routes.draw do
  mount Raddocs::App => '/docs'

  namespace :api do
    namespace :v1 do
      scope module: 'workers' do
        post 'authenticate', to: 'authentication#authenticate'
      end
    end
  end
end
