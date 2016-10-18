require_relative 'movement'
require 'colorize'
require 'byebug'

class Piece

  attr_accessor :color, :board, :pos

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
    #@board[pos] = self
  end

  def to_s
    # puts 'this was called'
    symbol = (self.symbol.force_encoding('utf-8') + ' ')
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
    # debugger
    self.moves.reject do |pos|
      move_into_check?(pos)
    end
  end

  private
  def move_into_check?(to_pos)
    # debugger if to_pos == [1, 4]
    new_board = board.dup
    new_board.move!(self.pos, to_pos)
    new_board.in_check?(self.color)
  end


end

class SlidingPiece < Piece
  def moves
    available_dirs = self.move_dirs
    final_locs = []
    available_dirs.each do |dir|
      dx, dy = dir
      x, y = self.pos
      x += dx
      y += dy
      while board.in_bounds?([x, y]) &&
          (board.grid[x][y].is_a?(NullPiece))
        final_locs << [x, y]
        x += dx
        y += dy
      end
      # debugger
      final_locs << [x, y] if board.in_bounds?([x, y]) && board.grid[x][y].color != self.color
    end
    final_locs
  end
end

class SteppingPiece < Piece
  def moves
    available_locs = self.move_diffs
    final_locs = []
    available_locs.each do |dx, dy|
      x, y = self.pos[0] + dx, self.pos[1] + dy
      final_locs << [x, y] if board.in_bounds?([x, y]) &&
                (board.grid[x][y].is_a?(NullPiece) || board.grid[x][y].color != self.color)
    end
    final_locs
  end
end
