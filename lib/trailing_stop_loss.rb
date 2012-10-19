class TrailingStopLoss
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
