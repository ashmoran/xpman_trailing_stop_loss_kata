require 'spec_helper'
require 'contracts/price_listener_contract'

require 'orders/test_order'
require 'limit_ratchets/delayed_limit_ratchet'

describe DelayedLimitRatchet do
  it "doesn't duplicate the Celluloid code" do
    pending
  end

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

  it_behaves_like "a PriceListener"

  let(:order) { TestOrder.new }
  subject(:ratchet) { DelayedLimitRatchet.new(order: order, opening_price: 21, delay: 0.05) }

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