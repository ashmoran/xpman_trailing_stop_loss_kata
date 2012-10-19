require 'spec_helper'
require 'support/market_agent_contract'

require 'market'
require 'market_agents/test_market_agent'

describe TestMarketAgent do
  let(:market)    { Market.new }
  subject(:agent) { TestMarketAgent.new(market: market) }

  it_behaves_like "a MarketAgent" do
    def sell
      agent.sell
      agent.allow_actions_to_complete
    end

    def belay
      agent.belay
    end
  end

  it_behaves_like "a DeferredMarketAgent" do
    def sell_without_completing
      agent.sell
    end

    def allow_actions_to_complete
      agent.allow_actions_to_complete
    end
  end

  context "when told to sell" do
    it "sells immediately" do
      agent.sell
      agent.allow_actions_to_complete
      expect(market.actions).to be == [ :sell ]
    end

    context "and sell again" do
      it "sells twice (because in the tests we want to prove the message was sent twice)" do
        agent.sell
        agent.sell
        agent.allow_actions_to_complete
        expect(market.actions).to be == [ :sell, :sell ]
      end
    end
  end

  context "when told to belay" do
    it "records that it was belayed" do
      agent.belay
      agent.allow_actions_to_complete
      expect(market.actions).to be == [ :belay ]
    end
  end

  it "plays actions in order" do
    agent.sell
    agent.belay
    agent.allow_actions_to_complete
    expect(market.actions).to be == [ :sell, :belay ]
  end
end

