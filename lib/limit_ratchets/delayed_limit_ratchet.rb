require 'celluloid'

require_relative '../interfaces/limit_ratchet'
require_relative '../timers/null_timer'

class DelayedLimitRatchet
  include LimitRatchet
  include Celluloid

  def initialize(dependencies)
    @order            = dependencies[:order]
    @last_known_price = dependencies[:opening_price]
    @delay            = dependencies[:delay]
    @timer            = NullTimer.new
  end

  def price_changed(new_price)
    @timer.cancel

    if new_price > @last_known_price
      @timer = after(@delay) do
        @order.update_limit(new_price - 1)
      end
    end

    @order.price_changed(new_price)
  end
end