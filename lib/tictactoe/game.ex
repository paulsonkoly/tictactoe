defmodule TicTacToe.Game do
  @moduledoc """
  The state of a tic tac toe game.

  Create a new state with `new_game`. Once a game has been created you
  can `query` a position on the board, place new marks on the board or query
  whose turn it is. If the game has finished `winner` should return the winning
  player, otherwise it returns `:nobody`.

  ## Example

  ```
  # after creating a new game position 1, 2 is empty
  iex> new_game() |> query(1, 2)
  :empty

  # there isn't a winner either
  iex> new_game() |> winner
  :nobody

  # place an X on the top left corner
  iex> new_game() |> update(0, 0) |> query(0, 0)
  :player_x

  # after a move it's the opposite players turn
  iex> new_game() |> update(0, 0) |> whos_next
  :player_o
  ```
  """

  @doc "Creates a new game with an empty board and `:player_x` to make a move."
  def new_game do
  end

  @doc "Returns the board content on the specified location."
  def query(state, x, y) do
  end

  @doc "Returns the next player to make a move."
  def whos_next(state) do
  end

  @doc "Returns the winner if there is one. Otherwise returns `:nobody`."
  def winner(state) do
  end

  @doc """
  Makes a move for the player who is next. Raises an error if the move is not
  possible because the position is occupied or the game has ended.
  """
  def update(state, x, y) do
  end
end
