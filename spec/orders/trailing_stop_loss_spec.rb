require 'spec_helper'
require 'contracts/price_listener_contract'

require 'orders/trailing_stop_loss'

describe TrailingStopLoss do
  let(:agent)     { TestMarketAgent.new }
  subject(:order) { TrailingStopLoss.new(limit: 9, market_agent: agent) }

  it_behaves_like "a PriceListener"

  context "price drops below limit" do
    it "sells" do
      order.price_changed(8)
      expect(agent.actions).to be == [ :sell ]
    end
  end

  context "price moves to the limit" do
    it "doesn't sell" do
      order.price_changed(9)
      expect(agent.actions).to_not include(:sell)
    end
  end

  context "price drops below, then rises to the limit" do
    it "belays the order" do
      order.price_changed(8)
      order.price_changed(9)
      expect(agent.actions).to be == [ :sell, :belay ]
    end
  end

  context "price drops below the limit, then drops further" do
    it "sells twice (because we want to let the agent decide how to handle this)" do
      order.price_changed(8)
      order.price_changed(7)
      expect(agent.actions).to be == [ :sell, :sell ]
    end
  end
end

