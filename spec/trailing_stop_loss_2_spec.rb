require 'spec_helper'
require 'trailing_stop_loss_2'

describe "Trailing Stop Loss 2" do
  include Market

  let(:agent) {
    ImmediateMarketAgent.new(self)
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

describe ImmediateMarketAgent, type: :market_agent do
  subject(:agent) { ImmediateMarketAgent.new(market: self) }

  context "when told to sell" do
    it "sells immediately" do
      agent.sell
      expect(actions).to be == [ :sell ]
    end
  end
end

describe DelayedMarketAgent, type: :market_agent do
  subject(:agent) { DelayedMarketAgent.new(market: self, delay: 0.1) }

  context "before the time specified" do
    it "does not sell" do
      expect(actions).to be_empty
    end
  end

  context "after the time specified" do
    it "sells" do
      expect(actions).to be == [ :sell ]
    end
  end
end
