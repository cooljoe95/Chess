# Chess
Attached is my implementation of chess. It features a guide that the user can use to show the available moves for a given piece. You are able to move around the board using the standard 'wasd' keys as well as the directional keys. This game was implemented in Ruby.

In order to run the program in your console, first download it as a zip, use the image below as a guide:
![link](/assets/download.png)

Unzip the file.

Go to the file in Finder and open a Terminal window. Type `cd ` and drag the folder to terminal window like so:
![link](/assets/terminal.png)


* **Before running the program**, I recommend increasing the zoom using cmd + '+'. For reference, it is roughly 24 characters wide. 

Press enter and then run the command:
```bash
ruby chess.rb
```

## Screenshot
### Beginning Board
![link](/assets/gameplay.png)

## Rules
For people already familiar with chess, this game does not implement Castling and En-passant and you can skip this section.

The goal of the game is to get your opponent's king before they get yours. Two of your pieces may not occupy the same space at the same time. For sliding pieces, you are not able to pass your piece to get an opponent's piece behind it. You are able to capture your opponents pieces as long as the piece is in your moves list. 

| Piece         | Name | Moves           |
| ------------- | :----------: | -------------|
| &#9817;      | Pawn | Pawns are able to move towards the opposing side in one step increments only. The only exception is its first move, where it can move two spaces. Additionally, they can only take another piece if that piece is one step diagonally away in the direction it is moving|
| &#9816;      | Knight      | Knights are able to move in an L direction. They must move one space in one of the four cardinal directions and two spaces perpendicular to the path just created.
| &#9815; | Bishop | Bishops are able to slide across the board, but only diagonally in one direction.
| &#9814; | Rook | Rooks are able to slide across the board in one fo the four cardinal directions.
| &#9813; | Queen | Queens are able to slide across the board in any direction.
| &#9812; | King | Kings are able to move one step in any direction. Guard Him with your life.

## Libraries Used
- Colorize - For styling
- "io/console" - For getting user input and interpreting it

## Technicalities

```ruby
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
```
```ruby
  def moves
    final_locs = []
    self.move_dirs.each do |dir|
      pos_moves = slide_moves(dir)
      final_locs += pos_moves if pos_moves.length > 0
    end
    final_locs
  end
 ```
For sliding pieces, which include the rook, bishop, and queen, the above code checks to ensure that the spaces are null and continues adding the spaces to the piece's possible location array. The last method call in slide moves `can_steal_piece!` checks to see whether or not you are at the edge of the board then check to see if the piece is of the other color and adds it to the pieces possible location array.

## Todo
In the future I hope to implement the en-passant and castling.
