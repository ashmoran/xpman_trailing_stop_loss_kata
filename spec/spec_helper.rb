require 'ap'

# Interface for self-shunt
module Market
  def sell
    @actions << :sell
  end

  def actions
    @actions
  end

  def initialize_market
    @actions = [ ]
  end
end

module EventDSL
  def when_event_happens(&block)
    before(:each, &block)
  end
end

RSpec.configure do |config|
  config.extend(EventDSL)

  config.include(Market, type: :market_agent)
  config.before(:each) do
    if example.metadata[:type] == :market_agent
      initialize_market
    end
  end
end
