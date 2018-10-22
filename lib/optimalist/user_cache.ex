defmodule Optimalist.UserCache do
  use GenServer
  alias Optimalist.Neo4j.Repo

  @server __MODULE__

  @doc false
  def start_link do
    GenServer.start_link(@server, %{}, name: @server)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def user_by_token(token) do
    GenServer.call(@server, {:user_by_token, token})
  end

  def handle_call({:user_by_token, token}, _from, state) do
    if Map.has_key?(state, token) do
      {:reply, {:ok, Map.get(state, token)}, state}
    else
      case Repo.user_by_token(token) do
        {:ok, user} -> {:reply, {:ok, user}, Map.put(state, token, user)}
        err -> {:reply, err, state}
      end
    end
  end
end
