class TooLateTimer
  def initialize(error)
    @error = error
  end

  def cancel
    raise @error
  end
end
