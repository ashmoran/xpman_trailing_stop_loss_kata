shared_examples_for "a PriceListener" do
  it { should be_a(PriceListener) }

  it "can listen for price changes" do
    expect {
      subject.price_changed(999)
    }.to_not raise_error
  end
end