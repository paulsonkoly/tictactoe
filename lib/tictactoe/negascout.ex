defmodule TicTacToe.Negascout do
  @moduledoc """
  Generic Negascout algorithm

  Given a function that can produce a list of moves from a node, a function
  that can evaluate a node (evaluation for tic tac toe is only done on terminal
  nodes), and a function that makes a move on a node, this returns the
  evaluation of a starting node and the best path (starting with the best move)

  Note: the only change needed to make this suitable for any game is to add a
  limit on the search and to call evaluation when the limit is hit.
  """

  defprotocol Node do
    @doc "generates a list of possible moves"
    def moves(node)

    @doc "makes a move on the given node returning the updated node"
    def make_move(node, move)

    @doc "evaluates the given node"
    def evaluate(node)
  end

  @doc """
  The negascout search (without depth limit)

  `player` should be set to 1 if the player with positive evaluation is next to
  move otherwise should be set to -1. `alpha` is the starting alpha value
  should be effectively -infinity. `beta` is the starting beta value, should be
  effectively +infinity. `node` has to implement the `TicTacToe.Negascout.Node`
  protocol.
  """
  def negascout(node, player, alpha, beta) do
    move_list = node |> Node.moves
    if Enum.empty? move_list do
      # exit of the recursion, the game is finished, no need to calculate any
      # further
      { player * Node.evaluate(node), [] }
    else
      move_list |> negascout_loop(node, player, alpha, beta, true)
    end
  end

  defp negascout_loop(_, _, _, _, _, _ , _ \\ [], _ \\ nil)
  defp negascout_loop([], _, _, alpha, _, _, ml, m), do: { alpha, [m | ml] }
  defp negascout_loop([move|loop_list], node, player, alpha, beta, first, pl, pm) do
    {score, ml } = node
                   |> negascout_search(move, player, alpha, beta, first)
    # update alpha
    { alpha, ml, pm } = if score > alpha, do: {score, ml, move},
                                          else: {alpha, pl, pm}
    if alpha >= beta do
      # beta cut off
      { alpha, [move|ml] }
    else
      negascout_loop(loop_list, node, player, alpha, beta, false, ml, pm)
    end
  end

  defp negate({score, movelist}), do: {-score, movelist}

  defp negascout_recurse(node, move, player, alpha, beta) do
    node
    |> Node.make_move(move)
    |> negascout(player, alpha, beta)
    |> negate
  end

  defp negascout_search(node, move, player, alpha, beta, true) do
    # initial search
    node |> negascout_recurse(move, -player, -beta, -alpha)
  end
  defp negascout_search(node, move, player, alpha, beta, false) do
    # null window search
    { score, ml} = node
                   |> negascout_recurse(move, -player, -alpha - 1, -alpha)
    if alpha < score && score < beta do
      # full search
      node |> negascout_recurse(move, -player, -beta, -score)
    else
      { score, ml }
    end
  end
end
