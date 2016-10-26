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
    puts 'Current Player: ' + @cur_color.to_s.upcase
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

  def color_square(loc, color)
    @board[loc].to_s.colorize(:background => color)
  end

  def grab_moves(loc)
    return [] if board[loc].color != @cur_color
    board[loc].valid_moves
  end


  def reset_selected!
    if cursor.selected_pos
      if @board[cursor.selected_pos].color != @cur_color
        cursor.selected_pos = nil
      end
    end
  end

  def unselected_valid_moves
    unless cursor.selected
      return grab_moves(cursor.cursor_pos)
    end
  end

  def selected_valid_moves
    if cursor.selected_pos
      return grab_moves(cursor.selected_pos)
    end
  end

  def cursor_moves
    reset_selected!
    selected_valid_moves || unselected_valid_moves
  end

  def get_color(pos_moves, loc)
    return :white if loc == cursor.selected_pos
    return :white if loc == cursor.cursor_pos
    return :light_blue if pos_moves.include?(loc)
    return (loc[0] + loc[1]) % 2 == 0 ? :green : :magenta
  end

  def color_row(pos_moves, i)
    colored_row = ""
    @board.grid.each_with_index do |cell, j|
      color = get_color(pos_moves, [i, j])
      colored_row << color_square([i, j], color)
    end
    colored_row
  end

  def color_board
    pos_moves = cursor_moves
    final = "\n   A  B  C  D  E  F  G  H\n"
    @board.grid.each_with_index do |row, i|
      final << "#{i} "
      final << color_row(pos_moves, i)
      final << " #{i}\n"
    end
    final << "   A  B  C  D  E  F  G  H\n"
  end


  def render
    print color_board ###Most Important String in the world.
    unless board.checkmate?(@cur_color)
      puts board.in_check?(@cur_color) ? 'in check' : ''
    end
    puts board.checkmate?(@cur_color) ? 'checkmate!' : ''
  end


end
