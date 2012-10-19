# Exactly the same as TestMarket now...
class TestMarketAgent
  def initialize
    @actions = [ ]
  end

  def sell
    @actions << :sell
  end

  def belay
    @actions << :belay
  end

  def actions
    @actions.dup
  end
end
