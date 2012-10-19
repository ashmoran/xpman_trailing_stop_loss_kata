require 'spec_helper'
require 'trailing_stop_loss'
require 'market'
require 'market_agents/test_market_agent'

describe TrailingStopLoss do
  let(:market)    { Market.new }
  let(:agent)     { TestMarketAgent.new(market: market) }
  subject(:order) { TrailingStopLoss.new(limit: 9, market_agent: agent) }

  context "price drops below limit" do
    it "sells" do
      order.price_changed(8)
      agent.allow_actions_to_complete
      expect(market.actions).to be == [ :sell ]
    end
  end

  context "price moves to the limit" do
    it "doesn't sell" do
      order.price_changed(9)
      agent.allow_actions_to_complete
      expect(market.actions).to_not include(:sell)
    end
  end

  context "price drops below, then rises to the limit" do
    it "belays the order" do
      order.price_changed(8)
      order.price_changed(9)
      agent.allow_actions_to_complete
      expect(market.actions).to be == [ :sell, :belay ]
    end
  end

  context "price drops below the limit, then drops further" do
    it "sells twice (because we want to let the agent decide how to handle this)" do
      order.price_changed(8)
      order.price_changed(7)
      agent.allow_actions_to_complete
      expect(market.actions).to be == [ :sell, :sell ]
    end
  end
end

