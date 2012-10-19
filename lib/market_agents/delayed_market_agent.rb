require 'celluloid'
require_relative '../interfaces/market_agent'
require_relative '../timers/null_timer'
require_relative '../timers/too_late_timer'

class DelayedMarketAgent
  include MarketAgent
  include Celluloid

  def initialize(dependencies)
    @market = dependencies[:market]
    @delay  = dependencies[:delay]
    @timer  = NullTimer.new
  end

  def sell
    @timer.cancel
    @timer = after(@delay) do
      @market.sell
      @timer = TooLateTimer.new(too_late_error)
    end
  end

  def belay
    @timer.cancel
  end

  private

  def too_late_error
    MarketAgent::ActionError.new("Sell order has already been issued")
  end
end