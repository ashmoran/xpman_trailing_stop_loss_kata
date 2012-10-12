require 'spec_helper'

class TrailingStopLoss
  def initialize(attributes)

  end

  def price_changed(new_price)

  end
end

describe "Trailing Stop Loss" do
  subject(:order) { TrailingStopLoss.new(limit: 9, market: self) }

  before(:each) do
    @actions = [ ]
  end

  def actions
    @actions
  end

  context "price goes up" do
    it "does not sell" do
      order.price_changed(11)
      expect(actions).to be_empty
    end
  end

  it "wipes the evil grin from @kevinrutherford's face" do
    pending
  end
end