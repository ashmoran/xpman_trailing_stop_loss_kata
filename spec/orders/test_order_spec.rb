require 'spec_helper'
require 'contracts/price_listener_contract'

require 'spec/test_order'

describe TestOrder do
  it_behaves_like "a PriceListener"
end