require 'ap'

module EventDSL
  def when_event_happens(&block)
    before(:each, &block)
  end
end

RSpec.configure do |config|
  config.extend(EventDSL)
end

# Interface for self-shunt
module Market
  def sell
    @actions << :sell
  end

  def actions
    @actions
  end

  def initialize_market
    @actions = [ ]
  end
end
