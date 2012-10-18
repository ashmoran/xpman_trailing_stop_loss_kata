require 'spec_helper'
require 'trailing_stop_loss_2'

describe "Trailing Stop Loss 2" do
  include Market

  let(:agent) {
    mock("MarketAgent").tap do |agent|
      agent.stub(:sell) do
        sell
      end
    end
  }

  subject(:order) { TrailingStopLoss2.new(limit: 9, market_agent: agent) }

  before(:each) do
    initialize_market
  end

  context "price drops below limit" do
    it "sells" do
      order.price_changed(8)
      expect(actions).to be == [ :sell ]
    end
  end

  context "price moves to the limit" do
    it "doesn't sell" do
      order.price_changed(9)
      expect(actions).to be_empty
    end
  end
end
