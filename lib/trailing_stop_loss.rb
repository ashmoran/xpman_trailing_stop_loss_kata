require_relative 'limit_ratchet'
require_relative 'stop_loss'
require_relative 'market_agent'

class TrailingStopLoss
  def initialize(config)
    @impl =
      LimitRatchet.new(
        opening_price:  config.fetch(:opening_price),
        delay:          config.fetch(:ratchet_delay),
        order: StopLoss.new(
          limit:        config.fetch(:opening_price) - 1,
          market_agent: MarketAgent.new(
            delay:  config.fetch(:sell_delay),
            market: config.fetch(:market)
          )
        )
      )
  end

  def price_changed(new_price)
    @impl.price_changed(new_price)
  end
end