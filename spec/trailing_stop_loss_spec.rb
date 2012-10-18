require 'spec_helper'
require 'trailing_stop_loss'

# describe "Trailing Stop Loss" do
#   include MarketSelfShunt

#   before(:each) do
#     initialize_market
#   end

#   subject(:order) {
#     TrailingStopLoss.new(limit: 9, current_time: 100, market: self)
#   }

#   shared_examples_for "a price increase" do
#     it_behaves_like "a still-pending order"
#   end

#   shared_examples_for "an insignificant drop" do
#     it_behaves_like "a still-pending order"
#   end

#   shared_examples_for "a sell order" do
#     it "sells" do
#       expect(actions).to be == [ :sell ]
#     end
#   end

#   shared_examples_for "a still-pending order" do
#     it "does not sell" do
#       expect(actions).to be_empty
#     end
#   end

#   shared_examples_for "an order with a limit of" do |limit|
#     it "has a limit of #{limit}" do
#       order.price_changed(price: limit - 1, time: Float::INFINITY)
#       expect(actions).to be == [ :sell ]
#     end
#   end

#   context "price goes up" do
#     context "for a significant time" do
#       when_event_happens do
#         order.price_changed(price: 11, time: 116)
#       end

#       it_behaves_like "a price increase"
#       it_behaves_like "an order with a limit of", 10

#       context "and then goes up again" do
#         context "for a significant time" do
#           when_event_happens do
#             order.price_changed(price: 12, time: 132)
#           end

#           it_behaves_like "a price increase"
#           it_behaves_like "an order with a limit of", 11
#         end

#         context "momentarily" do
#           when_event_happens do
#             order.price_changed(price: 12, time: 131)
#           end

#           it_behaves_like "a price increase"
#           it_behaves_like "an order with a limit of", 10
#         end
#       end
#     end

#     context "monentarily" do
#       when_event_happens do
#         order.price_changed(price: 11, time: 115)
#       end

#       it_behaves_like "a price increase"
#       it_behaves_like "an order with a limit of", 9
#     end
#   end

#   context "price goes down" do
#     context "to the limit" do
#       when_event_happens do
#         order.price_changed(price: 9, time: Float::INFINITY)
#       end

#       it_behaves_like "an insignificant drop"
#     end

#     context "below the limit" do
#       context "for a significant time" do
#         when_event_happens do
#           order.price_changed(price: 8, time: 131)
#         end

#         it_behaves_like "a sell order"
#       end

#       context "momentarily" do
#         when_event_happens do
#           order.price_changed(price: 8, time: 130)
#         end

#         it_behaves_like "a still-pending order"
#       end
#     end
#   end

#   # it "wipes the evil grin from @kevinrutherford's face" do
#   #   pending
#   # end
# end