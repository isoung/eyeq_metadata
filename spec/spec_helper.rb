require 'eyeq_metadata'
require 'webmock/rspec'
require 'yaml'

WebMock.disable_net_connect!(allow_localhost: true)
RSpec.configure do |config|
  config.mock_with :rspec
end
