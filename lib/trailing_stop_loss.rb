class TrailingStopLoss
  def initialize(attributes)
    @limit            = attributes[:limit]
    @last_known_time  = attributes[:current_time]
    @market           = attributes[:market]
  end

  def price_changed(price_info)
    new_price, price_time = price_info.values_at(:price, :time)

    if new_price < @limit
      @market.sell
    end
    if new_price > @limit && time_is_sufficient_for_limit_raise?(price_time)
      @limit = new_price - 1
    end
  end

  private

  def time_is_sufficient_for_limit_raise?(price_time)
    (price_time - @last_known_time) > 15
  end
end
