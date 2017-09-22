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
  considered a best path for both players.
  ```
  """
  def next_move(state) do
    next = case Game.whos_next state do
      :player_x -> 1
      :player_o -> -1
    end
    negascout(state, next, -10, 10)
  end

  defp negascout(state, player, alpha, beta) do
    if state |> Game.finished? do
      # exit of the recursion, the game is finished, no need to calculate any
      # further
      { player * evaluate(state), [] }
    else
      state
      |> Game.moves
      |> negascout_loop(state, player, alpha, beta, true)
   end
  end

  defp negascout_loop(_, _, _, _, _, _ , _ \\ [], _ \\ nil)
  defp negascout_loop([], _, _, alpha, _, _, ml, m), do: { alpha, [m | ml] }
  defp negascout_loop([move|loop_list], state, player, alpha, beta, first, pl, pm) do
    {score, ml } = state
                   |> negascout_search(move, player, alpha, beta, first)
    # update alpha
    { alpha, ml, pm } = if score > alpha, do: {score, ml, move},
                                          else: {alpha, pl, pm}
    if alpha >= beta do
      # beta cut off
      { alpha, [move|ml] }
    else
      negascout_loop(loop_list, state, player, alpha, beta, false, ml, pm)
    end
  end

  defp negate({score, movelist}), do: {-score, movelist}

  defp negascout_recurse(state, move, player, alpha, beta) do
    state
    |> Game.update(move)
    |> negascout(player, alpha, beta)
    |> negate
  end

  defp negascout_search(state, move, player, alpha, beta, true) do
    # initial search
    state |> negascout_recurse(move, -player, -beta, -alpha)
  end
  defp negascout_search(state, move, player, alpha, beta, false) do
    # null window search
    { score, ml} = state
                   |> negascout_recurse(move, -player, -alpha - 1, -alpha)
    if alpha < score && score < beta do
      # full search
      state |> negascout_recurse(move, -player, -beta, -score)
    else
      { score, ml }
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
