require_relative 'piece'

class Bishop < SlidingPiece
  # include Slidable

  def symbol
    "\u265D"
  end

  protected
  def move_dirs
    moves = [
      [-1, -1],
      [-1, 1],
      [1, -1],
      [1, 1]
    ]
  end
end
