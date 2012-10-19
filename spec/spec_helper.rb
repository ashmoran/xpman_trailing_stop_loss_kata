require 'ap'

require 'spec/test_market'
require 'spec/test_market_agent'
require 'spec/test_order'

require 'support/celluloid_helpers'

module EventDSL
  def when_event_happens(&block)
    before(:each, &block)
  end
end

RSpec.configure do |config|
  config.extend(EventDSL)
end
