require_relative 'cursor'
require_relative 'board'
require 'colorize'

class Display

  attr_accessor :cursor, :board, :cur_color

  def initialize(board)
    @cursor = Cursor.new([6,0], board)
    @cur_color = :white
    @board = board
  end

  def clear_display
    system('clear')
    puts 'current player: ' + @cur_color.to_s
    render
  end

  def select_start_pos
    clear_display
    start_pos = self.cursor.get_input

    if start_pos == nil || board[start_pos].color != @cur_color
      self.cursor.selected = false
    end

    start_pos
  end

  def select_end_pos
    clear_display
    self.cursor.get_input
  end

  def get_valid_position(beginorend)
    until self.cursor.selected
      pos = select_start_pos if beginorend == :start
      pos = select_end_pos if beginorend == :end
    end
    pos
  end

  def get_user_pos
    self.cursor.selected = false
    self.cursor.selected_pos = nil
    start_pos = get_valid_position(:start)

    self.cursor.selected = false
    end_pos = get_valid_position(:end)
    return start_pos, end_pos
  end

  def move(new_pos)
    loop do
      completed_move = board.move(@cur_color, *get_user_pos)
      if completed_move
        @cur_color = @cur_color == :white ? :black : :white
      end
    end
  end

  def color_the_squares
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
