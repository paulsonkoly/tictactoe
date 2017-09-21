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

  defmodule State do
    @moduledoc false
    # construct the initial board
    keys  = for x <- 0..2, y <- 0..2, do: {x, y}
    board = keys |> Enum.reduce(%{}, fn(k, h) -> Map.put(h, k, :empty) end)

    defstruct next_player: :player_x, board: board
  end

  @doc "Creates a new game with an empty board and `:player_x` to make a move."
  def new_game do
    %State{}
  end

  @doc "Returns the board content on the specified location."
  def query(state, x, y) do
    state.board[{x, y}]
  end

  @doc "Returns the next player to make a move."
  def whos_next(state) do
    state.next_player
  end

  @doc "Returns the winner if there is one. Otherwise returns `:nobody`."
  def winner(state) do
    :nobody
  end

  @doc """
  Makes a move for the player who is next. Raises an error if the move is not
  possible because the position is occupied or the game has ended.
  """
  def update(state = %State{ next_player: next, board: board}, x, y) do
    case who = query(state, x, y) do
      :empty ->
        state
        |> Map.put(:next_player, opponent(next))
        |> Map.put(:board, %{board | {x, y} => next } )
      _-> raise "position #{x}, #{y} is already occupied by #{who}"
    end
  end

  defp opponent(:player_x), do: :player_o
  defp opponent(:player_o), do: :player_x
end
