defmodule PangTest do
  use ExUnit.Case
  doctest Pang

  test "Game" do
    :random.seed(:os.timestamp)

    Game.start_link(10)
    Game.serve(40)

    :timer.sleep(1000)

    IO.puts "\n====="
    Game.report

    :timer.sleep(300)
  end
end
