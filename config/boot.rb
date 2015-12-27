ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)

require "bundler/setup" # Set up gems listed in the Gemfile.
Bundler.require(:default, ENV["RAILS_ENV"] || ENV["RACK_ENV"] || "development" )

Dotenv.load(
  File.expand_path("#{Rails.env}.env", __dir__)
) if defined?(Dotenv)
