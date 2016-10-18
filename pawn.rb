require_relative 'piece'

class Pawn < Piece

  def symbol
    "\u265F"
  end

  def moves
    dir = forward_dir
    if at_start_row?
      dir << [2 * dir[0][0], 0]
    end
    final_locs = []
    dir.each do |dx, dy|
      x, y = self.pos[0] + dx, self.pos[1] + dy
      final_locs << [x, y] if board.in_bounds?([x, y]) && board.grid[x][y].is_a?(NullPiece)
    end
    side_attacks.each do |dx, dy|
      x, y = self.pos[0] + dx, self.pos[1] + dy
      final_locs << [x, y] if board.in_bounds?([x, y]) &&
                (!board.grid[x][y].is_a?(NullPiece) && board.grid[x][y].color != self.color)
    end
    final_locs
  end

  protected

  def at_start_row?
    return self.pos[0] == 1 if self.color == :black
    return self.pos[0] == 6 if self.color == :white
  end

  def forward_dir
    return [[1, 0]] if self.color == :black
    return [[-1, 0]] if self.color == :white
  end

  def forward_steps

  end

  def side_attacks
    return [[1, -1], [1, 1]] if self.color == :black
    return [[-1, -1], [-1,1]]
  end
end
