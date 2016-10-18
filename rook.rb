require_relative 'piece'

class Rook < SlidingPiece
  # include Slidable

  def symbol
    # if color == :black
      "\u265C"
    # else
      # "\u2656"
    # end
  end

  protected
  def move_dirs
    moves = [
      [-1, 0],
      [0, -1],
      [1, 0],
      [0, 1]
    ]
  end
end
