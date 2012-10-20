require 'celluloid'

require_relative 'timers/null_timer'
require_relative 'timers/too_late_timer'

class MarketAgent
  include Celluloid

  class ActionError < RuntimeError; end

  def initialize(dependencies)
    @market = dependencies.fetch(:market)
    @delay  = dependencies.fetch(:delay)
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
    ActionError.new("Sell order has already been issued")
  end
end