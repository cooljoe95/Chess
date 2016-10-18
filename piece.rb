require 'colorize'
require 'byebug'

class Piece

  attr_accessor :color, :board, :pos

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
  end

  def to_s
    # puts 'this was called'
    symbol = (" " + self.symbol.force_encoding('utf-8') + " ")
    if self.color == :black
      symbol.colorize(:black)
    else
      symbol.colorize(:light_white)
    end
  end

  def empty?

  end

  def symbol

  end

  def valid_moves
    self.moves.reject do |pos|
      move_into_check?(pos)
    end
  end

  private
  def move_into_check?(to_pos)
    new_board = board.dup
    new_board.move!(self.pos, to_pos)
    new_board.in_check?(self.color)
  end

  def can_move?(loc)
    board.in_bounds?(loc) && board[loc].is_a?(NullPiece)
  end

end

class SlidingPiece < Piece

  def can_steal_piece!(final_locs, loc)
    if board.in_bounds?(loc) && board[loc].color != self.color
      final_locs << loc
    end
  end

  def slide_moves(dir)
    final_locs = []
    x, y = self.pos[0] + dir[0], self.pos[1] + dir[1]
    while can_move?([x, y])
      final_locs << [x, y]
      x, y = x + dir[0], y + dir[1]
    end
    can_steal_piece!(final_locs, [x, y])
    final_locs
  end

  def moves
    final_locs = []
    self.move_dirs.each do |dir|
      pos_moves = slide_moves(dir)
      final_locs += pos_moves if pos_moves.length > 0
    end
    final_locs
  end

end

class SteppingPiece < Piece

  def moves
    final_locs = []
    self.move_diffs.each do |dx, dy|
      x, y = self.pos[0] + dx, self.pos[1] + dy
      if board.in_bounds?([x, y]) && board.grid[x][y].color != self.color
        final_locs << [x, y]
      end
    end
    final_locs
  end

end
