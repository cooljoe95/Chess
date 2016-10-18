require 'colorize'
require_relative 'rook'
require_relative 'knight'
require_relative 'pawn'
require_relative 'queen'
require_relative 'king'
require_relative 'bishop'
require_relative 'null_piece'


class Board
  attr_accessor :grid

  def initialize(grid = Array.new(8) { Array.new(8) })
    @grid = grid
    make_starting_grid if grid[0][0].nil?
  end

  def move(color, start_pos, end_pos)
    # raise StandardError.new('Piece not found') if grid[start_pos].is_a?(NullPiece)
    # # TODO: raise StandardError.new('Cannot make move')
    if self[start_pos].valid_moves.include?(end_pos)
      move!(start_pos, end_pos)
    else
      false
    end
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    grid[x][y] = piece
  end

  def dup
    new_board = Board.new
    duped_grid = deep_dup(grid, new_board)
    new_board.grid = duped_grid
    new_board
  end

  def move!(start_pos, end_pos)
    self[start_pos].pos = nil unless self[start_pos].is_a?(NullPiece)
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.instance
    self[end_pos].pos = end_pos
  end

  def in_check?(color)
    king_pos = find_king(color)
    grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if cell.color != color
          return true if cell.moves.include?(king_pos)
        end
      end
    end
    false
  end

  def checkmate?(color)
    if in_check?(color)
      grid.each_with_index do |row, i|
        row.each_with_index do |cell, j|
          if cell.color == color
            return false unless cell.valid_moves.empty?
          end
        end
      end
      return true
    end
    false
  end

  def in_bounds?(pos)
    x, y = pos
    x.between?(0, grid.length - 1) && y.between?(0, grid.length - 1)
  end

  protected

  def populate_both_sides(piece, color, row, col)
    size = grid.length - 1
    grid[row][col] = piece.new(color, self, [row, col])
    grid[row][size - col] = piece.new(color, self, [row, size - col])
  end

  def populate_back_row(color, row)
    populate_both_sides(Rook, color, row, 0)
    populate_both_sides(Knight, color, row, 1)
    populate_both_sides(Bishop, color, row, 2)

    grid[row][3] = Queen.new(color, self, [row, 3])
    grid[row][4] = King.new(color, self, [row, 4])
  end

  def populate_pawns(color, row)
    8.times do |n|
      grid[row][n] = Pawn.new(color, self, [row, n])
    end
  end

  def populate_nulls
    (2..5).each do |i|
      8.times do |j|
        grid[i][j] = NullPiece.instance
      end
    end
  end

  def make_starting_grid
    populate_back_row(:black, 0)
    populate_pawns(:black, 1)
    populate_back_row(:white, 7)
    populate_pawns(:white, 6)

    populate_nulls
  end



  def find_king(color)
    grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        if cell.is_a?(King) && cell.color == color
          return [i,j]
        end
      end
    end
  end

  def dup_piece(el, new_board)
    if el.class == NullPiece
      return el.class.instance
    end
    el.class.new(el.color, new_board, el.pos)
  end

  def dup_row(el, new_board)
    if el.is_a?(Array)
      return deep_dup(el, new_board)
    end
    dup_piece(el, new_board)
  end

  def deep_dup(arr, new_board)
    arr.map { |el| dup_row(el, new_board) }
  end

end

board = Board.new
#puts board.in_check?(:black)
board[[2,4]].moves
