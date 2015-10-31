defmodule Game do
  use Supervisor

  def start_link(n) do
    Supervisor.start_link(__MODULE__, [n], [name: __MODULE__])
  end

  def init([n]) do
    children = Enum.map(1..n, fn _ -> worker(Player, [], id: make_ref) end)
    supervise(children, strategy: :one_for_one)
  end

  def get_players do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, pid, _, _} -> pid end)
    |> Enum.reject(fn pid -> pid == self end)
  end
end
