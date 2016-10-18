require_relative 'piece'

class Pawn < Piece

  def symbol
    "\u265F"
  end

  def side_steps(final_locs)
    side_attacks.each do |dx, dy|
      other_color = [:white, :black] - [self.color]
      loc = [self.pos[0] + dx, self.pos[1] + dy]
      if board.in_bounds?(loc) && board[loc].color == other_color[0]
        final_locs << loc
      end
    end
  end

  def moves
    final_locs = forward_steps
    side_steps(final_locs)
    final_locs
  end

  protected

  def at_start_row?
    return self.pos[0] == 1 if self.color == :black
    return self.pos[0] == 6 if self.color == :white
  end

  def forward_dir
    return [1, 0] if self.color == :black
    return [-1, 0] if self.color == :white
  end

  def forward_steps
    dir = forward_dir
    loc = [self.pos[0] + dir[0], self.pos[1] + dir[1]]
    final_locs = can_move?(loc) ? [loc] : []
    if final_locs.length > 0 && at_start_row?
      loc = [self.pos[0] + 2 * dir[0], self.pos[1]]
      final_locs << loc if can_move?(loc)
    end
    final_locs
  end

  def side_attacks
    return [[1, -1], [1, 1]] if self.color == :black
    return [[-1, -1], [-1,1]]
  end
end
