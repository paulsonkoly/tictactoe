# Tictactoe

My first Elixir project. Tic tac toe game. This program plays tic-tac-toe with you on a 3 by 3 board.

## Program structure

One module handles IO. Gets the user input, shows the user the current game state. In theory this could then be replaced with a GUI, web interface or whatever.

The game logic is handled by yet an other module. The API is pretty simple, given a game state it returns a move or it returns the winner.

  * `move(state)` -> `{ x, y }` | `:player_x` | `:player_o`

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tictactoe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tictactoe, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/tictactoe](https://hexdocs.pm/tictactoe).

