source 'https://rubygems.org'
gem 'rails', '3.2.13'
gem 'pg'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'capistrano'
gem "devise", "2.2.4"
gem "cancan"
gem "date_validator"
gem "rolify"
gem 'jquery-rails'
gem "client_side_validations", "~> 3.2.5"
gem "simple_form", "~> 2.1.0"
gem "client_side_validations-simple_form", "~> 2.1.0"
gem "haml-rails", "~> 0.4"
gem 'pg'
gem 'kaminari'
gem 'attribute_normalizer'
gem 'state_machine'
gem "meta_search"
gem "jquery-ui-rails"
gem 'acts_as_commentable'
gem 'newrelic_rpm', "3.5.8.72"
gem 'ruby-prof'
gem 'acts-as-taggable-on'
gem 'forem', :git => "https://github.com/radar/forem.git"
gem "paperclip", "~> 3.0"
gem 'twitter-bootstrap-rails'#, :git => 'https://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'handles_sortable_columns'
#Move these gem into test, development group. The Gem is not secure to remain here
gem 'ffaker'
gem 'populator'
gem 'exception_notification'
gem 'less-rails-bootstrap'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'less-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer', :platforms => :ruby
end

group :development do
  gem 'pry'
  gem 'annotate'
  gem 'thin'
end

group :test do
	gem "shoulda-matchers"
	gem 'database_cleaner'
	gem 'simplecov', :require => false
	gem 'rspec-rails-mocha'
	gem 'webmock'
end

group :test, :development do
	gem 'rspec-rails'
    gem 'poltergeist'
	gem "fabrication"
	gem "hoe", '2.8.0'
end
gem 'rails_12factor', group: :production
group :staging, :production do
  gem 'rvm-capistrano'
end
