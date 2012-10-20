require 'spec_helper'

require 'limit_ratchet'

describe LimitRatchet do
  include CelluloidHelpers

  let(:order) { TestOrder.new }
  subject(:ratchet) { LimitRatchet.new(order: order, opening_price: 21, delay: 0.05) }

  context "the price goes up" do
    context "for less than the delay" do
      it "does not update the limit" do
        expect {
          ratchet.price_changed(22)
          sleep 0.04
        }.to_not change { order.limit }
      end

      context "then goes up again" do
        it "does not update the limit" do
          expect {
            ratchet.price_changed(22)
            sleep 0.04
            ratchet.price_changed(23)
            sleep 0.02
          }.to_not change { order.limit }
        end
      end
    end

    context "for more than the delay" do
      it "updates the limit" do
        expect {
          ratchet.price_changed(22)
          sleep 0.06
        }.to change { order.limit }.to(21)
      end

      it "is idempotent" do
        expect {
          ratchet.price_changed(22)
          sleep 0.06
          ratchet.price_changed(22)
        }.to change { order.limit }.to(21)
      end

      context "then goes down" do
        it "doesn't let the limit go back down" do
          ratchet.price_changed(23)
          sleep 0.06
          ratchet.price_changed(22)
          sleep 0.06
          expect(order.limit).to be == 22
        end

        context "then goes back up again" do
          it "isn't fooled" do
            ratchet.price_changed(24)
            sleep 0.06
            ratchet.price_changed(22)
            sleep 0.06
            ratchet.price_changed(23)
            sleep 0.06
            expect(order.limit).to be == 23
          end
        end
      end
    end
  end

  context "the price goes down" do
    it "does not update the limit" do
      ratchet.price_changed(20)
      sleep 0.06
      expect(order.limit).to be == :initial_limit
    end
  end

  it "relays the price change" do
    ratchet.price_changed(30)
    expect(order.last_known_price).to be == 30
  end
end