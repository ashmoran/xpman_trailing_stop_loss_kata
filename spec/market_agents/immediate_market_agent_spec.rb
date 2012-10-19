require 'spec_helper'
require 'market_agents/immediate_market_agent'

describe ImmediateMarketAgent do
  let(:market)    { Market.new }
  subject(:agent) { ImmediateMarketAgent.new(market: market) }

  context "when told to sell" do
    it "sells immediately" do
      agent.sell
      expect(market.actions).to be == [ :sell ]
    end

    context "then told to belay" do
      it "raises an error" do
        agent.sell

        expect {
          agent.belay
        }.to raise_error(MarketAgent::ActionError, "Sell order has already been issued")
      end
    end
  end

  context "when told to belay" do
    it "does nothing" do
      agent.belay
      expect(market.actions).to be_empty
    end
  end
end
