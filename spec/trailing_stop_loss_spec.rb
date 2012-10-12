require 'spec_helper'
require 'trailing_stop_loss'

# Interface for self-shunt
module Market
  def sell
    @actions << :sell
  end

  def actions
    @actions
  end
end

describe "Trailing Stop Loss" do
  include Market

  before(:each) do
    @actions = [ ]
  end

  subject(:order) {
    TrailingStopLoss.new(limit: 9, current_time: 100, market: self)
  }

  shared_examples_for "a price increase" do
    it "does not sell" do
      expect(actions).to be_empty
    end
  end

  shared_examples_for "an order with a limit of" do |limit|
    it "has a limit of #{limit}" do
      order.price_changed(price: limit - 1, time: Float::INFINITY)
      expect(actions).to be == [ :sell ]
    end
  end

  context "price goes up" do
    context "for a significant time" do
      before(:each) do
        order.price_changed(price: 11, time: 116)
      end

      it_behaves_like "a price increase"
      it_behaves_like "an order with a limit of", 10

      context "and then goes up again" do
        before(:each) do
          # The price has already gone up once for a significant time
          order.price_changed(price: 11, time: 116)
        end

        context "for a significant time" do
          before(:each) do
            order.price_changed(price: 12, time: 132)
          end

          it_behaves_like "a price increase"
          it_behaves_like "an order with a limit of", 11
        end

        context "momentarily" do
          before(:each) do
            order.price_changed(price: 12, time: 131)
          end

          it_behaves_like "a price increase"
          it_behaves_like "an order with a limit of", 10
        end
      end
    end

    context "monentarily" do
      it_behaves_like "a price increase"
      it_behaves_like "an order with a limit of", 9
    end
  end

  context "price goes down to the limit" do
    it "does not sell" do
      order.price_changed(price: 9, time: -999)
      expect(actions).to be_empty
    end
  end

  context "price goes below the limit" do
    it "sells" do
      order.price_changed(price: 8, time: -999)
      expect(actions).to be == [ :sell ]
    end

    it "doesn't do this if the blip is temporary" do
      pending
    end
  end

  it "wipes the evil grin from @kevinrutherford's face" do
    pending
  end
end