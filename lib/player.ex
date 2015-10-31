defmodule Player do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    :random.seed(:os.timestamp)
    GenServer.cast(self, {:serve_ball})
    {:ok, %{points: 0}}
  end

  def handle_cast({:receive_ball, from_pid}, state) do
    IO.puts("Ball Received #{inspect from_pid}")
    case maybe() do
      true ->
        IO.puts("Hit in #{inspect self}")
        GenServer.cast(self, {:serve_ball})
      false ->
        IO.puts("Miss in #{inspect self}")
        GenServer.cast(from_pid, :score)
    end
    {:noreply, state}
  end

  def handle_cast({:serve_ball}, state) do
    to_pid = Game.get_players
             |> Enum.at(:random.uniform(3))
    IO.puts("Serve Ball to #{inspect to_pid}")
    GenServer.cast(to_pid, {:receive_ball, self})
    {:noreply, state}
  end

  def handle_cast(:score, %{points: points}) do
    new_state = %{points: points + 1}
    IO.puts("Score for #{inspect self}: #{new_state.points}")
    {:noreply, new_state}
  end

  #Private

  defp maybe do
    :random.uniform > 0.33
  end
end
