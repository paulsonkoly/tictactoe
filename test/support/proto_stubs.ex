defimpl TicTacToe.Negascout.Node, for: Atom do
  def moves(:a), do: [:a]
  def moves(:b), do: []

  def make_move(_, _), do: :b

  def evaluate(:a), do: 3
  def evaluate(:b), do: 4
end
