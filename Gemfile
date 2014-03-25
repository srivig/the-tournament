source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.3'
gem 'pg'
gem 'foreman'
gem 'unicorn'
gem 'newrelic_rpm'

gem 'sass-rails', '~> 4.0.0'
gem 'haml-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'quiet_assets'
gem 'kaminari'
gem 'gon'
gem 'acts-as-taggable-on'
gem 'countries'
gem 'country_select'
gem 'world_flags', git: 'git://github.com/djonasson/world_flags.git'

#Bootstrap
gem 'therubyracer', platforms: :ruby
gem 'less-rails'
gem 'twitter-bootstrap-rails', github: 'seyhunak/twitter-bootstrap-rails', branch: 'bootstrap3'
gem 'simple_form', git: 'https://github.com/plataformatec/simple_form.git'

#User Authentication
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

group :doc do
  gem 'sdoc', require: false
end

group :production do
  gem 'rails_12factor'
  gem 'google-analytics-rails'
end

group :development do
  gem 'erb2haml'
end

group :test do
  gem 'rake'
  gem 'faker'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'fuubar'
end

group :development, :test do
  gem 'travis'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'pry-rails'
  gem 'pry-debugger'
  gem "factory_girl_rails"
end
