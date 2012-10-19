require_relative 'market_agent'

class ImmediateMarketAgent
  extend MarketAgent

  def initialize(dependencies)
    @market = dependencies[:market]
  end

  def sell
    @market.sell

    # Look ma, no instance state
    def self.belay
      raise MarketAgent::ActionError.new("Sell order has already been issued")
    end
  end

  def belay
    # NOOP
  end
end
