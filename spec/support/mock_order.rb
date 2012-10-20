class MockOrder
  def initialize
    @limit            = :initial_limit
    @last_known_price = :initial_price
  end

  def update_limit(new_limit)
    @limit = new_limit
  end

  def limit
    @limit
  end

  def price_changed(new_price)
    @last_known_price = new_price
  end

  def last_known_price
    @last_known_price
  end
end