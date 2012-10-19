require 'spec_helper'
require 'contracts/price_listener_contract'

require 'orders/test_order'
require 'limit_ratchets/immediate_limit_ratchet'

describe ImmediateLimitRatchet do
  it_behaves_like "a PriceListener"

  let(:order) { TestOrder.new }
  subject(:ratchet) { ImmediateLimitRatchet.new(order: order, opening_price: 21) }

  context "the price goes down" do
    it "does not update the limit" do
      ratchet.price_changed(20)
      expect(order.limit).to be == :initial_limit
    end
  end

  context "the price goes up" do
    it "updates the limit" do
      ratchet.price_changed(22)
      expect(order.limit).to be == 21
    end
  end

  it "relays the price change" do
    ratchet.price_changed(30)
    expect(order.last_known_price).to be == 30
  end
end