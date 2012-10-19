require 'celluloid'
require_relative 'market_agent'

class DelayedMarketAgent
  include MarketAgent
  include Celluloid

  class NullTimer
    def cancel
      # NOOP
    end
  end

  class TooLateTimer
    def cancel
      raise MarketAgent::ActionError.new("Sell order has already been issued")
    end
  end

  NULL_TIMER = NullTimer.new
  TOO_LATE_TIMER = TooLateTimer.new

  def initialize(dependencies)
    @market = dependencies[:market]
    @delay  = dependencies[:delay]
    @timer  = NULL_TIMER
  end

  def sell
    @timer.cancel
    @timer = after(@delay) do
      @market.sell
      @timer = TOO_LATE_TIMER
    end
  end

  def belay
    @timer.cancel
  end
end