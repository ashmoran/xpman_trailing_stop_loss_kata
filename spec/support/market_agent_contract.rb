EXPECTED_METHODS = [ :sell, :belay ]

shared_examples_for "a MarketAgent" do
  it { should be_a(MarketAgent) }

  before(:each) do
    unless EXPECTED_METHODS.all? { |message| respond_to?(message) }
      raise RuntimeError.new(missing_helper_error_message)
    end
  end

  describe "#sell" do
    it "sells" do
      sell
      expect(market.actions).to be == [ :sell ]
    end

    context "called twice" do
      it "does not raise an error" do
        sell
        sell
      end
    end
  end

  context "when told to belay" do
    it "doesn't raise an error" do
      belay
    end
  end

  def missing_helper_error_message
    "MarketAgent example groups must define: " +
      EXPECTED_METHODS.map { |method| "##{method}" }.join(", ")
  end
end