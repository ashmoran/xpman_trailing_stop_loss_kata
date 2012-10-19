require 'contracts/price_listener_contract'

shared_examples_for "a LimitRatchet" do
  it_behaves_like "a PriceListener"

  it { should be_a(LimitRatchet) }

  it "relays the price change" do
    ratchet.price_changed(30)
    expect(order.last_known_price).to be == 30
  end
end