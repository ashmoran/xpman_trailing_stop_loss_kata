require 'spec_helper'
require 'support/market_agent_contract'

require 'test_market'
require 'market_agents/test_market_agent'

describe TestMarketAgent do
  let(:market)    { TestMarket.new }
  subject(:agent) { TestMarketAgent.new(market: market) }

  # This class most definitely is NOT a DeferredMarketAgent!
  # It's just a dumb delegator.
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

    context "and sell again" do
      it "sells twice (because in the tests we want to prove the message was sent twice)" do
        agent.sell
        agent.sell
        expect(market.actions).to be == [ :sell, :sell ]
      end
    end
  end

  context "when told to belay" do
    it "records that it was belayed" do
      agent.belay
      expect(market.actions).to be == [ :belay ]
    end
  end

  it "plays actions in order" do
    agent.sell
    agent.belay
    expect(market.actions).to be == [ :sell, :belay ]
  end
end

