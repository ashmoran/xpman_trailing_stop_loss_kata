class TrailingStopLoss2
  def initialize(attributes)
    @limit = attributes[:limit]
    @agent = attributes[:market_agent]
  end

  def price_changed(new_price)
    @agent.sell if new_price < @limit
  end
end

module MarketAgent

end

class ImmediateMarketAgent
  extend MarketAgent

  def initialize(market)
    @market = market
  end

  def sell
    @market.sell
  end
end

class DelayedMarketAgent
  extend MarketAgent

  def initialize(market)
    @market = market
  end

  def sell

  end
end