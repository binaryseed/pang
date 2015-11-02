defmodule Player do
  use GenServer
  @skill 0.33

  def start_link(n), do: GenServer.start_link(__MODULE__, [n])

  def init([n]) do
    {:ok, %{number: n, balls_won: []}}
  end

  def serve(pid, n),   do: GenServer.cast(pid, {:serve, n})
  def receive(pid, n), do: GenServer.cast(pid, {:receive, self, n, swing()})
  def score(pid, n),   do: GenServer.cast(pid, {:score, n})
  def report(pid),     do: GenServer.cast(pid, :report)

  def handle_cast({:receive, _from, ball, true}, state) do
    Player.serve(self, ball)
    IO.write(">")
    {:noreply, state}
  end

  def handle_cast({:receive, from, ball, false}, state) do
    Player.score(from, ball)
    IO.write("-")
    {:noreply, state}
  end

  def handle_cast({:serve, ball}, state) do
    Game.players
    |> Enum.random
    |> Player.receive(ball)
    IO.write("}")
    {:noreply, state}
  end

  def handle_cast({:score, ball}, %{balls_won: balls} = state) do
    IO.write("!")
    {:noreply, Map.put(state, :balls_won, balls ++ [ball])}
  end

  def handle_cast(:report, state) do
    IO.puts("##{state.number}: #{Enum.count state.balls_won}, #{inspect state.balls_won}")
    {:noreply, state}
  end

  defp swing(), do: :random.uniform > @skill
end
