require 'spec_helper'
require 'trailing_stop_loss_2'
require 'celluloid/rspec'

class Market
  def initialize
    @actions = [ ]
  end

  def sell
    @actions << :sell
  end

  def belay
    @actions << :belay
  end

  def actions
    @actions.dup
  end
end

describe "Trailing Stop Loss 2" do
  let(:market)    { Market.new }
  let(:agent)     { TestMarketAgent.new(market: market) }
  subject(:order) { TrailingStopLoss2.new(limit: 9, market_agent: agent) }

  context "price drops below limit" do
    it "sells" do
      order.price_changed(8)
      expect(market.actions).to be == [ :sell ]
    end
  end

  context "price moves to the limit" do
    it "doesn't sell" do
      order.price_changed(9)
      expect(market.actions).to_not include(:sell)
    end
  end

  context "price drops below, then rises to the limit" do
    it "belays the order" do
      order.price_changed(8)
      order.price_changed(9)
      expect(market.actions).to be == [ :sell, :belay ]
    end
  end
end

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

describe DelayedMarketAgent do
  let(:market)    { Market.new }
  subject(:agent) { DelayedMarketAgent.new(market: market, delay: 0.05) }

  context "when told to sell" do
    context "before the specified sell delay" do
      it "has not not sold" do
        agent.sell
        # I don't know how fine we can push this until it becomes intermittent
        sleep 0.04
        expect(market.actions).to be_empty
      end

      context "then told to belay" do
        it "does not sell" do
          agent.sell
          sleep 0.04
          agent.belay
          sleep 0.02
          expect(market.actions).to be_empty
        end

        it "is idempotent" do
          agent.sell
          sleep 0.04
          agent.belay
          agent.belay
          sleep 0.02
          expect(market.actions).to be_empty
        end
      end
    end

    context "after the time specified" do
      it "sells" do
        agent.sell
        sleep 0.06
        expect(market.actions).to be == [ :sell ]
      end

      context "when told to belay" do
        it "raises an error" do
          agent.sell
          sleep 0.06

          expect {
            agent.belay
          }.to raise_error(MarketAgent::ActionError, "Sell order has already been issued")
        end
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
