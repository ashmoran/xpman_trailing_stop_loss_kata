require 'spec_helper'
require 'contracts/market_agent_contract'

require 'test_market'
require 'market_agents/immediate_market_agent'

describe ImmediateMarketAgent do
  let(:market)    { TestMarket.new }
  subject(:agent) { ImmediateMarketAgent.new(market: market) }

  it_behaves_like "a MarketAgent" do
    def sell
      agent.sell
    end

    def belay
      agent.belay
    end
  end

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

    context "and sell again" do
      it "sells just once (because the contract for this interface allows multiple sells)" do
        agent.sell
        agent.sell
        expect(market.actions).to be == [ :sell ]
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
