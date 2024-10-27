defmodule SourShark.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Registry.child_spec(
        keys: :duplicate,
        name: SourShark.EventRegistry.FileChange
      ),
      {Bandit, scheme: :http, plug: SourShark.Router, port: 8080},
      SourShark.FileSystemWatcher
    ]

    opts = [strategy: :one_for_one, name: SourShark.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
