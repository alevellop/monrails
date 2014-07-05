source 'https://rubygems.org'

ruby '2.1.0'
#ruby-gemset=monrails

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# DDBB noSQL MongoDB
gem 'mongoid', git: 'https://github.com/mongoid/mongoid.git'
gem 'bson_ext'

group :development do
	# replaces the standard Rails error page with a useful error page.
	gem 'better_errors'
	gem 'binding_of_caller'
end

group :development, :test do
	# testing framework for Rails.
	gem 'rspec-rails'
	# to automatize test only over the files modified.
	gem 'guard-rspec'
	# to loads the environment once, so maintains a pool of processes for running future tests.
	gem 'spork-rails'
	gem 'guard-spork'
	gem 'childprocess'
end

group :test do
	# writes automated tests of website mimicing the behavior of a real user.
	gem 'selenium-webdriver'
	# tool to testing. It simulates a user interacting with the website.
	gem 'capybara'
	# Clean database before tests
	gem 'database_cleaner', github: 'bmabey/database_cleaner'

	gem 'mongoid-rspec'
	# Generate factories to define objects and insert them in th DB.
	gem 'factory_girl_rails'
end

group :production do	
	# to compile assets for Heroku
	gem 'rails_12factor'
end

# To upload files to AWS
gem 'mongoid-paperclip', require: "mongoid_paperclip"
gem 'aws-sdk'
# To pagination objects with Zurb Foundation
gem 'will_paginate'
gem 'will_paginate-foundation'
# To make sample users with semi-realistic names and emails addresses
gem 'faker'
# To irreversibly transform password to make the password hash
gem 'bcrypt-ruby'
# Framework to design the front-end
gem 'foundation-rails'
# templating engine for HTML
gem 'haml'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end