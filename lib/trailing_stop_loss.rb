class TrailingStopLoss
  def initialize(attributes)
    @limit  = attributes[:limit]
    @market = attributes[:market]
  end

  def price_changed(new_price)
    if new_price < @limit
      @market.sell
    end
  end
end
