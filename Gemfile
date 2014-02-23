source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'simple_form'
gem 'twitter-bootstrap-rails'
gem 'chosen-rails'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'delocalize'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'ransack'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
	gem 'coffee-rails'
  gem 'sass-rails',   '~> 3.2.3'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
  gem 'less'
end

gem 'jquery-rails'
gem 'less-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

group :production do
  gem 'pg'
end

group :development do
  gem 'unicorn'
  gem 'railroady'
  gem 'quiet_assets'
  gem 'sqlite3'
  gem 'yaml_db'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'faker'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'launchy'
end
