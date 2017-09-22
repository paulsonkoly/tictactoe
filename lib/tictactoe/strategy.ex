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

  Returns a tuple with the evaluation and the calculated move list that's
  considered a best path for both players. `move_list` is the accumulator in
  the recursion.

  ## Example

  ```
  iex> Game.new_game |> next_move
  0
  ```
  """
  def next_move(state, player \\ 1, alpha \\ -10, beta \\ 10) do
    if state |> Game.finished? do
      # exit of the recursion, the game is finished, no need to calculate any
      # further
      player * evaluate(state)
    else
      state |> Game.moves |> negascout_loop(state, player, alpha, beta, true)
   end
  end

  defp negascout_loop(loop_list, state, player, alpha, beta, first \\ false)
  defp negascout_loop([], _, _, alpha, _, _), do: alpha
  defp negascout_loop([move|loop_list], state, player, alpha, beta, first) do
    score = if first do
      -next_move(Game.update(state, move), -player, -beta, -alpha)
    else
      # null window search
      score = -next_move(Game.update(state, move), -player, -alpha - 1, -alpha)
      if alpha < score && score < beta do
        # full search
        -next_move(Game.update(state, move), -player, -beta, -score)
      else
        score
      end
    end
    alpha = max(alpha, score)
    if alpha >= beta do
      # beta cut off
      alpha
    else
      negascout_loop(loop_list, state, player, alpha, beta)
    end
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
