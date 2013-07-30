source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'unicorn'
gem 'haml-rails'
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'sidekiq'
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'
gem 'stripe'
gem 'stripe_event'
gem 'figaro'
gem 'draper'
gem 'jquery-rails'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'fabrication'
  gem 'simplecov', :require => false
  gem 'fivemat'
  gem 'rspec-rails', '~> 2.0'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'capybara-email'
  gem 'vcr'
  gem 'webmock', '1.11.0'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end

group :test, :development do
  gem 'faker'
  gem 'launchy'
end

group :development do
  gem 'thin'
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem 'quiet_assets'
  gem 'letter_opener'
end

group :production do
  gem 'pg'
end
