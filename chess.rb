require_relative 'board'
require_relative 'display'

b = Board.new
d = Display.new(b)
d.move([0,0]) ##Do Not Delete, does the running
