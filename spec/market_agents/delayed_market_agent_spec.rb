require 'spec_helper'
require 'support/market_agent_contract'

require 'market'
require 'market_agents/delayed_market_agent'

describe DelayedMarketAgent do
  let(:logger) { Logger.new(StringIO.new) }

  around(:each) do |example|
    original_logger = Celluloid.logger
    Celluloid.logger = logger
    example.run
    Celluloid.logger = original_logger
  end

  after(:all) do
    Celluloid.logger = nil
  end

  let(:market)    { Market.new }
  subject(:agent) { DelayedMarketAgent.new(market: market, delay: 0.05) }

  it_behaves_like "a MarketAgent" do
    def sell
      agent.sell
      sleep 0.06
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
      sleep 0.06
    end
  end

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

      context "and sell again" do
        it "resets the timer (because we assume the price has changed)" do
          agent.sell
          sleep 0.04
          agent.sell
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
