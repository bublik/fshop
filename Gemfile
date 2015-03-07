source 'https://rubygems.org'
ruby '2.2.0'

gem 'rails', '4.2.0'
# Use mysql as the database for Active Record
gem 'mysql2'
gem 'aasm'
gem 'awesome_nested_set'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

gem "elasticsearch", git: "git://github.com/elasticsearch/elasticsearch-ruby.git"
gem "elasticsearch-model", git: "git://github.com/elasticsearch/elasticsearch-rails.git"
gem "elasticsearch-rails", git: "git://github.com/elasticsearch/elasticsearch-rails.git"

# # Use SCSS for stylesheets
# gem 'sass', '~> 3.3.9'
# gem 'sass-rails'#, '~> 4.0.3'
gem 'less-rails-bootstrap', '~> 3.2.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails' #, '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'haml-rails'
gem 'simple_form'
gem 'draper', '~> 1.3.1'
gem 'kaminari'
gem 'acts-as-taggable-on'
gem 'friendly_id', '~> 5.0.0'
gem 'ckeditor'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'mini_magick'
gem 'carrierwave'
gem 'goods'

group :development do
  gem 'letter_opener'
  gem 'better_errors'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'capistrano', '~> 3.2.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq' , github: 'seuros/capistrano-sidekiq'
  gem 'capistrano-rvm', '~> 0.1', require: false
end

group :development, :test do
  gem 'factory_girl_rails', '~> 4.4.1', require: false
  gem 'rspec-rails'
  gem 'faker', '~> 1.4.1'
end

group :test do
  gem 'database_cleaner', '~> 1.3.0'
  gem 'minitest'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'simplecov-rcov'
end
