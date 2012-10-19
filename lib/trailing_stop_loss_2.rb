require 'celluloid'

class TrailingStopLoss2
  def initialize(attributes)
    @limit = attributes[:limit]
    @agent = attributes[:market_agent]
  end

  def price_changed(new_price)
    if new_price < @limit
      @agent.sell
    else
      @agent.belay
    end
  end
end

module MarketAgent

end

class TestMarketAgent
  extend MarketAgent

  def initialize(dependencies)
    @market = dependencies[:market]
  end

  def sell
    @market.sell
  end

  def belay
    @market.belay
  end
end

class ImmediateMarketAgent
  extend MarketAgent

  def initialize(dependencies)
    @market = dependencies[:market]
  end

  def sell
    @market.sell
  end
end

class DelayedMarketAgent
  extend MarketAgent
  include Celluloid

  def initialize(dependencies)
    @market = dependencies[:market]
    @delay = dependencies[:delay]
  end

  def sell
    after(@delay) do
      @market.sell
    end
  end
end