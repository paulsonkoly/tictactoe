defmodule TicTacToe.StrategyTest do
  alias TicTacToe.{Strategy, Game, Negascout}

  use ExUnit.Case, async: true
  doctest TicTacToe.Strategy, import: true

  test "newly created game cannot be evaluated" do
    catch_error Game.new_game |> Strategy.evaluate
  end

  test "when x wins evaluation is 1" do
    game = Game.new_game
           |> Game.update(0, 0)
           |> Game.update(0, 1)
           |> Game.update(1, 0)
           |> Game.update(1, 1)
           |> Game.update(2, 0)
    assert game |> Negascout.Node.evaluate == 1
  end

  test "when it's a draw the evaluation is 0" do
    # X O X
    # O O X
    # X X O
    game = Game.new_game
           |> Game.update(0,0) |> Game.update(1, 0) |> Game.update(2, 0)
           |> Game.update(1,1) |> Game.update(1, 2) |> Game.update(0, 1)
           |> Game.update(2,1) |> Game.update(2, 2) |> Game.update(0, 2)
    assert game |> Negascout.Node.evaluate == 0
  end
end
