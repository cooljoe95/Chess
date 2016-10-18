require_relative 'piece'

class King < SteppingPiece
  # include Stepable

  def symbol

    "\u265A"

  end

  protected
  def move_diffs
    moves = [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1]
    ]
  end

end
