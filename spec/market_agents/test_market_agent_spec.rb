require 'spec_helper'
require 'market'
require 'market_agents/test_market_agent'

describe TestMarketAgent do
  let(:market)    { Market.new }
  subject(:agent) { TestMarketAgent.new(market: market) }

  context "when told to sell" do
    it "sells immediately" do
      agent.sell
      expect(market.actions).to be == [ :sell ]
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

