defmodule Game do
  use Supervisor

  def start_link(n), do: Supervisor.start_link(Game, n, [name: __MODULE__])

  def init(players) do
    Enum.map(1..players, &worker(Player, [&1], id: &1))
    |> supervise(strategy: :one_for_one)
  end

  def players() do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, pid, _, _} -> pid end)
  end

  def serve(balls) do
    for n <- 1..balls do
      Game.players
      |> Enum.random
      |> Player.serve(n)
    end
  end

  def report() do
    Game.players
    |> Enum.map(&Player.report(&1))
  end
end
