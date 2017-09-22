defmodule TicTacToe.Strategy do
  alias TicTacToe.Game

  @moduledoc """
  Calculates the AI's next move

  There are maximum of 9 possible moves and maximum of 9 levels in the game
  tree. We just calculate them all. A win for `:player_x` is +1 a draw is 0 and
  a win for `:player_o` is -1. We implement the negascout algorithm that goes
  to the game end.
  """

  @doc """
  Calculates the next move of the AI

  ## Example

  ```
  iex> Game.new_game |> next_move
  { 0, 0 }
  ```
  """
  def next_move(state) do
    { 0, 1 }
  end

  @doc """
  Calculates the evaluation of a finishing position

  One of `-1`, `0`, `1` for the given board depending on who is winning. Raises
  an error if the game is not in a finished state.
  """
  def evaluate(state) do
    if state |> Game.finished? do
      case state |> Game.winner do
        :player_x -> 1
        :player_o -> -1
        :nobody -> 0
      end
    else
      raise "evaluate called on a game that hasn't finished yet"
    end
  end
end
