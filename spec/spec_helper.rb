ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'vcr'
require 'oj'

module DefineScenario
  def self.included(klass)
    klass.instance_eval do
      alias_example_to :scenario
    end
  end
end

Dir[Rails.root.join('spec/support/**/*.rb')].each do |file|
  require file
end

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

Oj.default_options = { mode: :compat }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.order = 'random'
  config.include DefineScenario
  config.include Rack::Test::Methods
  config.include ApiHelper

  config.before type: :request do
    send_and_accept_json
  end

  if defined? Sidekiq
    require 'sidekiq/testing/inline'
  end
end

Rails.logger.level = 4
