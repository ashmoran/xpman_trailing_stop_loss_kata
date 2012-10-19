require 'spec_helper'
require 'contracts/price_listener_contract'

require 'orders/test_order'

describe TestOrder do
  it_behaves_like "a PriceListener"
end