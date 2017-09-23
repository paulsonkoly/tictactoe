defmodule TicTacToe.Negascout do
  @moduledoc """
  Generic Negascout algorithm

  For information on the negascout algorithm please refer to
  https://en.wikipedia.org/wiki/Principal_variation_search. Before you can use
  this module you have to implement the `TicTacToe.Negascout.Node` protocol for
  your type.
  """

  defprotocol Node do
    @doc "generates a list of possible moves"
    def moves(node)

    @doc "makes a move on the given node returning the updated node"
    def make_move(node, move)

    @doc "evaluates the given node"
    def evaluate(node)
  end

  alias TicTacToe.Negascout.SearchState
  defmodule SearchState do
    @moduledoc false
    defstruct [ :depth, :best_move, best_path: [], first: true ]
  end

  @doc """
  The negascout search

  `node` has to implement the `TicTacToe.Negascout.Node`. `player` should be
  set to 1 if the player with positive evaluation is next to move otherwise
  should be set to -1. `alpha` is the starting alpha value should be
  effectively -infinity. `beta` is the starting beta value, should be
  effectively +infinity.
  """
  def negascout(node, depth, player, alpha, beta) do
    negascout_intern(node, player, alpha, beta, %SearchState{depth: depth})
  end

  defp negascout_intern(node, player, alpha, beta, state) do
    move_list = node |> Node.moves
    if Enum.empty?(move_list) or state.depth == 0 do
      # exit of the recursion, the game is finished, no need to calculate any
      # further
      { player * Node.evaluate(node), [] }
    else
      move_list |> negascout_loop(node, player, alpha, beta, state)
    end
  end

  defp negascout_loop([], _, _, alpha, _, state) do
    {alpha, [state.best_move|state.best_path]}
  end

  defp negascout_loop([move|loop_list], node, player, alpha, beta, state) do
    {score, ml} = negascout_search(move, node, player, alpha, beta, state)
    # update alpha
    {alpha, state} = if score > alpha do
      {score, %{state| best_move: move, best_path: ml}}
    else
      {alpha, state}
    end
    if alpha >= beta do
      # beta cut off
      { alpha, [move|ml] }
    else
      state = %{state|first: false}
      negascout_loop(loop_list, node, player, alpha, beta, state)
    end
  end

  defp negascout_search(move, node, player, alpha, beta,
                        state = %SearchState{first: true}) do
    # initial search
    negascout_recurse(move, node, -player, -beta, -alpha, state)
  end

  defp negascout_search(move, node, player, alpha, beta,
                        state = %SearchState{first: false}) do
    # null window search
    {score, ml} = negascout_recurse(move, node, -player, -alpha - 1, -alpha, state)
    if alpha < score && score < beta do
      # full search
      negascout_recurse(move, node, -player, -beta, -score, state)
    else
      {score, ml}
    end
  end

  defp negate({score, movelist}), do: {-score, movelist}

  defp negascout_recurse(move, node, player, alpha, beta, state) do
    state = state |> Map.update!(:depth, &(&1 + 1))
    node
    |> Node.make_move(move)
    |> negascout_intern(player, alpha, beta, state)
    |> negate
  end
end
