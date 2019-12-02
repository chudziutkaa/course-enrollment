require 'simplecov'

SimpleCov.start do
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Services', 'app/services'
end
