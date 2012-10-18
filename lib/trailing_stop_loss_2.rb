class TrailingStopLoss2
  def initialize(attributes)
    @limit = attributes[:limit]
    @agent = attributes[:market_agent]
  end

  def price_changed(new_price)
    @agent.sell if new_price < @limit
  end
end