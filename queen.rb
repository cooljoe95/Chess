require_relative 'piece'

class Queen < SlidingPiece
  # include Slidable

  def symbol
    "\u265B"
  end

  protected
  def move_dirs
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
