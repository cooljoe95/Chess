class NullPiece

  # include Singleton
  def initialize(*arg1)
  end

  def moves
    []
  end

  def valid_moves
    moves
  end

  def color
    nil
  end

  def to_s
    "  "
  end

  def empty?

  end

  def pos

  end

end
