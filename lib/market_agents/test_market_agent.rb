require_relative 'market_agent'

class TestMarketAgent
  include MarketAgent

  def initialize(dependencies)
    @market             = dependencies[:market]
    @queued_actions     = [ ]
    @performed_actions  = [ ]
  end

  def sell
    if @performed_actions.include?(:sell)
      raise MarketAgent::ActionError.new("Sell order has already been issued")
    end

    @queued_actions.<<(:sell)
  end

  def belay
    @queued_actions.<<(:belay)
  end

  def allow_sell_to_complete
    @queued_actions.each do |action|
      @market.send(action)
      @performed_actions << action
    end
    @queued_actions.clear
  end
end
