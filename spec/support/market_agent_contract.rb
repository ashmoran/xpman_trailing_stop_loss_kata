EXPECTED_METHODS = [ :sell, :belay ]

shared_context "MarketAgent context" do
  def expect_helper_methods(*expected_methods)
    unless expected_methods.all? { |message| respond_to?(message) }
      raise RuntimeError.new(missing_helper_error_message(expected_methods))
    end
  end

  def missing_helper_error_message(expected_methods)
    "Expected helper methods: " +
      expected_methods.map { |method| "##{method}" }.join(", ")
  end
end

shared_examples_for "a MarketAgent" do
  include_context "MarketAgent context"

  before(:each) do
    expect_helper_methods(:sell, :belay, :market)
  end

  it { should be_a(MarketAgent) }

  describe "#sell" do
    it "sells" do
      sell
      expect(market.actions).to be == [ :sell ]
    end
  end

  context "when told to belay" do
    it "doesn't raise an error" do
      expect {
        belay
      }.to_not raise_error
    end
  end
end
