source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'bcrypt', '~> 3.1', '>= 3.1.13'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rack-cors'
gem 'raddocs', '~> 2.2'
gem 'rails', '6.0.1'

group :development, :test do
  gem 'factory_bot', '~> 4.8', '>= 4.8.2'
  gem 'faker', '~> 2.7'
  gem 'jwt', '~> 2.2', '>= 2.2.1'
  gem 'pry', '~> 0.12.2'
  gem 'rspec-rails', '~> 3.9'
  gem 'rspec_api_documentation', '~> 6.1'
  gem 'shoulda-matchers', '~> 4.1', '>= 4.1.2'
  gem 'timecop', '~> 0.9.1'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', '0.77.0', require: false
  gem 'rubocop-performance', '~> 1.5', '>= 1.5.1'
  gem 'rubocop-rails', '~> 2.4'
end

group :test do
  gem 'database_cleaner', '~> 1.7'
  gem 'simplecov', '~> 0.17.1', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
