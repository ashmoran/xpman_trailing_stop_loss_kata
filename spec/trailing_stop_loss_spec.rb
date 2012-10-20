require 'spec_helper'

require 'trailing_stop_loss'

describe TrailingStopLoss do
  include CelluloidHelpers

  let(:market) { MockMarket.new }

  subject(:order) {
    TrailingStopLoss.new(
      market:         market,
      opening_price:  10,
      ratchet_delay:  0.15,
      sell_delay:     0.30
    )
  }

  context "the price dips briefly" do
    it "doesn't sell" do
      order.price_changed(8)
      sleep 0.29
      order.price_changed(9)
      sleep 0.02
      expect(market.actions).to be_empty
    end
  end

  context "the price tanks" do
    it "sells" do
      order.price_changed(8)
      sleep 0.31
      expect(market.actions).to be == [ :sell ]
    end
  end

  context "the price dips then soars" do
    it "doesn't sell" do
      order.price_changed(9)
      sleep 0.29
      order.price_changed(100)
      sleep 0.31
      expect(market.actions).to be_empty
    end
  end

  context "the price soars then tanks" do
    it "sells" do
      order.price_changed(100)
      sleep 0.16
      order.price_changed(98)
      sleep 0.31
      expect(market.actions).to be == [ :sell ]
    end
  end

  it "doesn't duplicate the limit generation algorithm" do
    pending
  end
end