defmodule TicTacToe.NegascoutTest do
  use ExUnit.Case, async: true
  alias TicTacToe.Negascout

  test "negascout stops at depth 0" do
    assert Negascout.negascout(:a, 0, 1, -10, 10) == {3, []}
  end
end
