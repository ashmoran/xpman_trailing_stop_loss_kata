require 'spec_helper'
require 'trailing_stop_loss'

  # Interface for self-shunt
  module Market
    def sell
      @actions << :sell
    end

    def actions
      @actions
    end
  end

describe "Trailing Stop Loss" do
  include Market

  before(:each) do
    @actions = [ ]
  end

  subject(:order) { TrailingStopLoss.new(limit: 9, market: self) }

  context "price goes up" do
    it "does not sell" do
      order.price_changed(11)
      expect(actions).to be_empty
    end

    it "moves the limit up" do
      order.price_changed(11)
      order.price_changed(9)
      expect(actions).to be == [ :sell ]
    end

    it "doesn't do this if the blip is temporary" do
      pending
    end
  end

  context "price goes down to the limit" do
    it "does not sell" do
      order.price_changed(9)
      expect(actions).to be_empty
    end
  end

  context "price goes below the limit" do
    it "sells" do
      order.price_changed(8)
      expect(actions).to be == [ :sell ]
    end

    it "doesn't do this if the blip is temporary" do
      pending
    end
  end

  it "wipes the evil grin from @kevinrutherford's face" do
    pending
  end
end