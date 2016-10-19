require_relative 'piece'

class Knight < SteppingPiece

  def symbol
      "\u265E"
  end

  protected
  def move_diffs
    moves = [
      [-2, -1],
      [-2, 1],
      [-1, -2],
      [-1, 2],
      [1, 2],
      [1, -2],
      [2, 1],
      [2, -1]
    ]
  end

end
