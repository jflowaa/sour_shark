defmodule SourShark.FileSystemWatcher do
  use GenServer
  @root_dir File.cwd!()
  @watch_dir ["#{@root_dir}/lib/sour_shark/templates", "#{@root_dir}/priv/posts"]

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(_args) do
    Mix.Tasks.Build.build_output(true, true)
    {:ok, watcher_pid} = FileSystem.start_link(dirs: @watch_dir, latency: 0)
    FileSystem.subscribe(watcher_pid)
    IO.puts("Watching for file changes at:\n\t- #{Enum.join(@watch_dir, "\n\t- ")}")
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid} = state) do
    IO.puts("File event: #{inspect(path)} -> #{inspect(events)}")
    IEx.Helpers.recompile()
    Mix.Tasks.Build.build_output(true, false)

    Registry.dispatch(SourShark.EventRegistry.FileChange, :file_change, fn entries ->
      for {pid, _} <- entries, do: send(pid, :broadcast)
    end)

    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    IO.puts("File watcher stopped")
    {:noreply, state}
  end
end
