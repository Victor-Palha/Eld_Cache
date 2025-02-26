defmodule EldCache.Cache do
  use GenServer

  @ets_table :eld_cache

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    :ets.new(@ets_table, [:set, :public, :named_table])
    {:ok, state}
  end

  def put(key, value, ttl \\ :infinity) do
    GenServer.call(__MODULE__, {:put, key, value, ttl})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def handle_call({:put, key, value, ttl}, _from, state) do
    :ets.insert(@ets_table, {key, value})
    if ttl != :infinity, do: Process.send_after(self(), {:expire, key}, ttl)
    {:reply, :ok, state}
  end

  def handle_call({:get, key}, _from, state) do
    case :ets.lookup(@ets_table, key) do
      [{^key, value}] -> {:reply, {:ok, value}, state}
      [] -> {:reply, :not_found, state}
    end
  end

  def handle_info({:expire, key}, state) do
    :ets.delete(@ets_table, key)
    {:noreply, state}
  end
end
