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
      expect {
        agent.belay
      }.to change { market.actions }.from([ ]).to([ :belay ])
    end
  end
end

