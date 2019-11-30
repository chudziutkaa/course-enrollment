Rails.application.routes.draw do
  mount Raddocs::App => '/docs'
end
