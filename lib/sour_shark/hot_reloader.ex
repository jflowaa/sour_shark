defmodule SourShark.HotReloader do
  def init(_) do
    Process.send_after(self(), :register_event, 1000)
    {:ok, %{}}
  end

  def handle_in(_, state) do
    {:ok, state}
  end

  def handle_info(:broadcast, state) do
    {:reply, :ok, {:text, "reload"}, state}
  end

  def handle_info(:register_event, state) do
    Registry.register(SourShark.EventRegistry.FileChange, :file_change, %{})
    {:ok, state}
  end

  def handle_info({:EXIT, _pid, _reason}, state) do
    {:stop, :normal, state}
  end

  def terminate(_reason, state) do
    {:ok, state}
  end
end
