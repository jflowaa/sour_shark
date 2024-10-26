defmodule SourShark.Router do
  use Plug.Router
  use Plug.ErrorHandler

  alias SourShark.Plug.ServeFiles

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get _ do
    ServeFiles.call(conn, %{})
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)
    send_resp(conn, conn.status, "Encountered an error that cannot be handled")
  end
end
