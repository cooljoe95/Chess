# Chess
Attached is my implementation of chess. It features a guide that the user can use to show the available moves for a given piece. You are able to move around the board using the standard 'wasd' keys as well as the directional keys. This game was implemented in Ruby.

* **Before running the program**, I recommend increasing the zoom using cmd + '+'. For reference, it is roughly 24 characters wide. 

In order to run the program in your console, go to the file in the terminal, and run
```bash
ruby chess.rb
```

## Rules
The goal of the game is to get your opponent's king before they get yours. Two of your pieces may not occupy the same space at the same time. For sliding pieces, you are not able to pass your piece to get an opponent's piece behind it. You are able to capture your opponents pieces as long as the piece is in your moves list.

| Piece         | Name | Moves           |
| ------------- | :----------: | -------------|
| &#9817;      | Pawn | Pawns are able to move towards the opposing side in one step increments only. The only exception is its first move, where it can move two spaces. Additionally, they can only take another piece if that piece is one step diagonally away in the direction it is moving|
| &#9816;      | Knight      | Knights are able to move in an L direction. They must move one space in one of the four cardinal directions and two spaces perpendicular to the path just created.
| &#9815; | Bishop | Bishops are able to slide across the board, but only diagonally in one direction.
| &#9814; | Rook | Rooks are able to slide across the board in one fo the four cardinal directions.
| &#9813; | Queen | Queens are able to slide across the board in any direction.
| &#9812; | King | Kings are able to move one step in any direction. Guard Him with your life.
