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

  context "price goes up" do
    context "for a significant time" do
      it "does not sell" do
        order.price_changed(price: 11, time: 116)
        expect(actions).to be_empty
      end

      it "moves the limit up" do
        order.price_changed(price: 11, time: 116)
        order.price_changed(price:  9, time: 117)
        expect(actions).to be == [ :sell ]
      end

      context "and then goes up again" do
        before(:each) do
          # The price has already gone up once for a significant time
          order.price_changed(price: 11, time: 116)
        end

        context "for a significant time" do
          it "does not sell" do
            order.price_changed(price: 12, time: 132)
            expect(actions).to be_empty
          end

          it "moves the limit up" do
            order.price_changed(price: 12, time: 132)
            order.price_changed(price: 10, time: 133)
            expect(actions).to be == [ :sell ]
          end
        end

        context "momentarily" do
          it "does not move the limit up" do
            order.price_changed(price: 12, time: 131)
            order.price_changed(price: 10, time: 132)
            expect(actions).to be_empty
          end
        end
      end
    end

    context "monentarily" do
      it "does not sell" do
        order.price_changed(price: 11, time: 115)
        expect(actions).to be_empty
      end

      it "does not move the limit up" do
        order.price_changed(price: 11, time: 115)
        order.price_changed(price:  9, time: 116)
        expect(actions).to be_empty
      end
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