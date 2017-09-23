defmodule TicTacToe.NegascoutTest do
  use ExUnit.Case, async: true
  alias TicTacToe.Negascout

  test "negascout stops at depth 0" do
    assert Negascout.negascout(:a, 0, 1, -10, 10) == {3, []}
  end

  test "negascout stops on terminal nodes" do
    assert Negascout.negascout(:b, 100, 1, -10, 10) == {4, [] }
  end

  test "negascout reaches one node from the other" do
    assert Negascout.negascout(:a, 1, 1, -10, 10) == {4, [:a] }
  end
end
