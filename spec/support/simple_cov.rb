require 'simplecov'

SimpleCov.start do
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
end
