require_relative 'market_agent'

class TestMarketAgent
  include MarketAgent

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
