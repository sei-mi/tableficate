ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../test_app/config/environment", __FILE__)

require 'capybara/rspec'
require 'capybara/rails'
