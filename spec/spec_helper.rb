require 'ap'

require 'support/mock_market'
require 'support/mock_market_agent'
require 'support/mock_order'

require 'support/celluloid_helpers'

module EventDSL
  def when_event_happens(&block)
    before(:each, &block)
  end
end

RSpec.configure do |config|
  config.extend(EventDSL)
end
