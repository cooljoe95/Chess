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
    #debugger
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
    self[start_pos] = NullPiece.new
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
  def make_starting_grid
    grid[0][0] = Rook.new(:black, self, [0, 0])
    grid[0][7] = Rook.new(:black, self, [0, 7])
    grid[0][1] = Knight.new(:black, self, [0, 1])
    grid[0][6] = Knight.new(:black, self, [0, 6])
    grid[0][2] = Bishop.new(:black, self, [0, 2])
    grid[0][5] = Bishop.new(:black, self, [0, 5])
    grid[0][3] = Queen.new(:black, self, [0, 3])
    grid[0][4] = King.new(:black, self, [0, 4])

    8.times do |n|
      grid[1][n] = Pawn.new(:black, self, [1, n])
    end

    grid[7][0] = Rook.new(:white, self, [7, 0])
    grid[7][7] = Rook.new(:white, self, [7, 7])
    grid[7][1] = Knight.new(:white, self, [7, 1])
    grid[7][6] = Knight.new(:white, self, [7, 6])
    grid[7][2] = Bishop.new(:white, self, [7, 2])
    grid[7][5] = Bishop.new(:white, self, [7, 5])
    grid[7][3] = Queen.new(:white, self, [7, 3])
    grid[7][4] = King.new(:white, self, [7, 4])

    8.times do |n|
      grid[6][n] = Pawn.new(:white, self, [6, n])
    end

    # nullpiece = Singleton::NullPiece.new
    (2..5).each do |i|
      8.times do |j|
        grid[i][j] = NullPiece.new
      end
    end
    #
    # grid[1][4] = Rook.new(:white, self, [1, 4])
    # grid[2][4] = Rook.new(:white, self, [2, 4])
    # p (grid[1][3]).valid_moves
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

  def deep_dup(arr, new_board)
    arr.map { |el| el.is_a?(Array) ? deep_dup(el, new_board) : el.class.new(el.color, new_board, el.pos) }
  end

end

board = Board.new
#puts board.in_check?(:black)
board[[2,4]].moves
