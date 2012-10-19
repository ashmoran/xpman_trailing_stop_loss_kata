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

  def initialize(dependencies)
    @market = dependencies[:market]
    @delay  = dependencies[:delay]
    @timer  = NullTimer.new
  end

  def sell
    @timer.cancel
    @timer = after(@delay) do
      @market.sell
      @timer = TooLateTimer.new
    end
  end

  def belay
    @timer.cancel
  end
end