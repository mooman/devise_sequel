ENV["RAILS_ENV"] = "test"
DEVISE_ORM = :sequel
DEVISE_PATH = ENV['DEVISE_PATH']

puts "\n==> Devise.orm = :sequel"

require "rails_app/config/environment"
require "rails/test_help"
require "orm/sequel"

I18n.load_path << "#{DEVISE_PATH}/test/support/locale/en.yml"
require 'mocha'
require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

Devise::Oauth.test_mode!

# Add support to load paths so we can overwrite broken webrat setup
$:.unshift "#{DEVISE_PATH}/test/support"
Dir["#{DEVISE_PATH}/test/support/**/*.rb"].each { |f| require f }
