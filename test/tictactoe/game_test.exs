defmodule TicTacToe.GameTest do
  use ExUnit.Case, async: true
  doctest TicTacToe.Game, import: true

  alias TicTacToe.Game

  test "creates an empty board" do
    game = Game.new_game()
    for x <- 0..2 do
      for y <- 0..2 do
        assert game |> Game.query(x, y) == :empty
      end
    end
  end

  test "updating the same field twice" do
    catch_error (Game.new_game() |> Game.update(0, 0) |> Game.update(0,0))
  end

  test "updating the game outside of the board" do
    catch_error (Game.new_game |> Game.update(10,10))
  end
end
