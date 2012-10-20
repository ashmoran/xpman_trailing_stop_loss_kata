require 'spec_helper'
require 'contracts/limit_ratchet_contract'

require 'limit_ratchets/immediate_limit_ratchet'

describe ImmediateLimitRatchet do
  it_behaves_like "a LimitRatchet"

  let(:order) { TestOrder.new }
  subject(:ratchet) { ImmediateLimitRatchet.new(order: order, opening_price: 21) }

  context "the price goes down" do
    it "does not update the limit" do
      ratchet.price_changed(20)
      expect(order.limit).to be == :initial_limit
    end
  end

  context "the price goes up" do
    it "updates the limit" do
      ratchet.price_changed(22)
      expect(order.limit).to be == 21
    end

    context "then goes down" do
      it "doesn't let the limit go back down" do
        ratchet.price_changed(23)
        ratchet.price_changed(22)
        expect(order.limit).to be == 22
      end

      context "then goes back up again" do
        it "isn't fooled" do
          ratchet.price_changed(24)
          ratchet.price_changed(22)
          ratchet.price_changed(23)
          expect(order.limit).to be == 23
        end
      end
    end
  end
end