require "io/console"

KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board
  attr_accessor :selected, :selected_pos

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
    @selected = false
    @selected_pos = nil
  end

  def get_input
    key = KEYMAP[read_char]
    begin
      handle_key(key)
    rescue StandardError => e
    end
  end

  private

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def handle_key(key)
    case key
    when :return, :space
      @selected = true
      @selected_pos = @cursor_pos
      @cursor_pos
    when :left, :right, :up, :down
      update_pos(MOVES[key])
    when :ctrl_c
      Process.exit(0)
    end
  end

  def update_pos(diff)
    dx, dy = diff
    x, y = cursor_pos
    new_pos = [x + dx, y + dy]
    raise StandardError.new('Out of bounds') unless board.in_bounds?(new_pos)
    @cursor_pos = [x + dx, y + dy]
  end

end
