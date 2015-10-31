defmodule PangTest do
  use ExUnit.Case
  doctest Pang

  test "ok pid" do
    # Game.start_link(5)
    # {:ok, pid1} = Player.start_link
    # {:ok, pid2} = Player.start_link
    # GenServer.cast(pid1, {:receive_ball, self})
    # GenServer.cast(pid1, {:serve_ball})
    # :timer.sleep(50)
  end

  test "Game" do
    Game.start_link(5)
    IO.inspect(Game.get_players)
    :timer.sleep(100)
  end
end
