require 'ap'

require 'support/celluloid_helpers'

module EventDSL
  def when_event_happens(&block)
    before(:each, &block)
  end
end

RSpec.configure do |config|
  config.extend(EventDSL)
end
