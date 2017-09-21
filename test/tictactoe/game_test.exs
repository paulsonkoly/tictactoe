defmodule TicTacToe.GameTest do
  use ExUnit.Case, async: true
  doctest TicTacToe.Game, import: true

  alias TicTacToe.Game

  test "creates an empty board" do
    game = Game.new_game()
    for x <- 0..2, y <- 0..2 do
      assert game |> Game.query(x, y) == :empty
    end
  end

  test "updating the same field twice" do
    catch_error (Game.new_game() |> Game.update(0, 0) |> Game.update(0,0))
  end

  test "updating the game outside of the board" do
    catch_error (Game.new_game |> Game.update(10,10))
  end

  test "when a player wins the winner returns that player" do
    # X O _
    # X O _
    # X _ _
    game = Game.new_game
           |> Game.update(0, 0)
           |> Game.update(0, 1)
           |> Game.update(1, 0)
           |> Game.update(1, 1)
           |> Game.update(2, 0)
    assert Game.winner(game) == :player_x
  end
end
