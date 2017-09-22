defmodule TicTacToe.Strategy do
  alias TicTacToe.{ Game, Negascout }

  @moduledoc """
  Calculates the AI's next move

  There are maximum of 9 possible moves and maximum of 9 levels in the game
  tree. We just calculate them all. A win for `:player_x` is +1 a draw is 0 and
  a win for `:player_o` is -1. We implement the negascout algorithm that goes
  to the game end.
  """

  defimpl Negascout.Node, for: Game.State do
    def moves(game), do: Game.moves(game)
    def make_move(game, {x, y}), do: Game.update game, x, y
    def evaluate(game) do
      case game |> Game.winner do
        :player_x -> 1
        :player_o -> -1
        :nobody -> 0
      end
    end
  end

  @doc """
  Calculates the next move of the AI

  Returns a tuple with the evaluation and the calculated move list that's
  considered a best path for both players.
  """
  def next_move(state) do
    next = case Game.whos_next state do
      :player_x -> 1
      :player_o -> -1
    end
    Negascout.negascout(state, next, -10, 10)
  end
end
