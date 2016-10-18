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
    ## Capture enemy and get them off board
    self[start_pos].pos = nil unless self[start_pos].class == NullPiece
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.instance
    self[end_pos].pos = end_pos
  end

  def search_grid
    grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        yield(cell)
      end
    end
  end

  def in_check?(color)
    king_pos = find_king(color)

    search_grid do |piece|
      if piece.color != color && piece.moves.include?(king_pos)
        return true
      end
    end

    false
  end

  def no_valid_moves?(color)
    search_grid do |piece|
      if piece.color == color && !piece.valid_moves.empty?
        return false
      end
    end

    true
  end

  def checkmate?(color)
    if in_check?(color)
      return no_valid_moves?(color)
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
    search_grid do |piece|
      if piece.is_a?(King) && piece.color == color
        return [i,j]
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
