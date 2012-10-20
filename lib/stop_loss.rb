require 'celluloid'

class StopLoss
  include Celluloid

  def initialize(attributes)
    @limit = attributes.fetch(:limit)
    @agent = attributes.fetch(:market_agent)
  end

  def price_changed(new_price)
    if new_price < @limit
      @agent.sell
    else
      @agent.belay
    end
  end

  def update_limit(new_limit)
    @limit = new_limit
  end
end
