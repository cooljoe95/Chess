require_relative 'cursor'
require_relative 'board'
require 'colorize'

class Display

  attr_accessor :cursor, :board, :cur_color

  def initialize(board)
    @cursor = Cursor.new([0,0], board)
    @cur_color = :white
    @board = board
  end

  def move(new_pos)
    loop do
      cursor.selected = false
      cursor.selected_pos = nil

      until cursor.selected
        system('clear')
        puts 'current player: ' + @cur_color.to_s
        render
        start_pos = self.cursor.get_input
        if start_pos == nil
          cursor.selected = false
        else
          unless board[start_pos].color == @cur_color
            cursor.selected = false
          end
        end
      end

      cursor.selected = false

      until cursor.selected
        system('clear')
        puts 'current player: ' + @cur_color.to_s
        render
        end_pos = self.cursor.get_input
      end

      j = board.move(@cur_color, start_pos, end_pos)
      @cur_color = @cur_color == :white ? :black : :white if j
    end
  end

  def render
    final = ''

    unless cursor.selected
      moves = board[cursor.cursor_pos].valid_moves
      moves = [] if board[cursor.cursor_pos].color != @cur_color
    end

    if cursor.selected_pos
      moves = board[cursor.selected_pos].valid_moves
      moves = [] if board[cursor.selected_pos].color != @cur_color
    end

    board.grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|

        if [i, j] == cursor.selected_pos
          final << (board.grid[i][j]).to_s.colorize(:background => :blue)

        elsif [i, j] == cursor.cursor_pos
          final << (board.grid[i][j]).to_s.colorize(:background => :light_yellow)

        elsif moves.include?([i,j])
          final << (board.grid[i][j]).to_s.colorize(:background => :white)

        else
          if i.even? && j.even? || i.odd? && j.odd?
            final << (board.grid[i][j]).to_s.colorize(:background => :light_magenta)
          else
            final << (board.grid[i][j]).to_s.colorize(:background => :cyan)
          end
        end

      end

      final << "\n"
    end

    print final ###Most Important String in the world.

    puts board.in_check?(@cur_color) ? 'in check' : '' unless board.checkmate?(@cur_color)
    puts board.checkmate?(@cur_color) ? 'checkmate!' : ''
  end


end
