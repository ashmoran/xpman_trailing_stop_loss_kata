require_relative 'price_listener_contract'

shared_examples_for "an Order" do
  it_behaves_like "a PriceListener"

  it { should be_an(Order) }

  it "can have its limit updated" do
    expect {
      subject.price_changed(999)
    }.to_not raise_error
  end
end
