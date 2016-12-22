source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'sqlite3'
gem 'puma', '~> 3.0'
gem 'rack-cors', :require => 'rack/cors'
gem 'active_model_serializers', '~> 0.10.0'

# Auth
gem 'devise_token_auth'
gem 'omniauth-twitter'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'rb-fsevent' if `uname` =~ /Darwin/
  gem 'factory_girl'
  gem 'simplecov', :require => false
  gem 'coveralls', :require => false
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
