require 'spec_helper'
require 'contracts/order_contract'

require 'spec/test_order'

describe TestOrder do
  it_behaves_like "an Order"
end