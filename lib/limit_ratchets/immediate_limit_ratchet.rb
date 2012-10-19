require_relative '../price_listener'

class ImmediateLimitRatchet
  include PriceListener

  def initialize(dependencies)
    @order            = dependencies[:order]
    @last_known_price = dependencies[:opening_price]
  end

  def price_changed(new_price)
    if new_price > @last_known_price
      @order.update_limit(new_price - 1)
    end

    @order.price_changed(new_price)
  end
end