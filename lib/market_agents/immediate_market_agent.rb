require_relative '../interfaces/market_agent'

class ImmediateMarketAgent
  include MarketAgent

  def initialize(dependencies)
    @market = dependencies[:market]
  end

  def sell
    @market.sell

    # Look ma, no instance state
    def self.belay
      raise MarketAgent::ActionError.new("Sell order has already been issued")
    end

    def self.sell
      # NOOP
    end
  end

  def belay
    # NOOP
  end
end
