require 'ap'

# Interface for self-shunt
class Market
  def initialize
    @actions = [ ]
  end

  def sell
    @actions << :sell
  end

  def actions
    @actions
  end
end

module MarketSelfShunt
  def initialize_market
    @market = Market.new
  end

  def sell
    @market.sell
  end

  def actions
    @market.actions
  end
end

module EventDSL
  def when_event_happens(&block)
    before(:each, &block)
  end
end

RSpec.configure do |config|
  config.extend(EventDSL)

  config.include(MarketSelfShunt, type: :market_agent)
  config.before(:each) do
    if example.metadata[:type] == :market_agent
      initialize_market
    end
  end
end
