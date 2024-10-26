defmodule SourShark.Plug.ServeFiles do
  @output_dir "./output"

  def init(options), do: options

  def call(%Plug.Conn{request_path: path} = conn, _opts) do
    if path == "/",
      do: serve_file(conn, "/index"),
      else: serve_file(conn, path)
  end

  defp serve_file(conn, path) do
    desired_path =
      if path |> Path.extname() == "",
        do: "#{@output_dir}#{path}.html",
        else: "#{@output_dir}#{path}"

    case File.read(desired_path) do
      {:ok, content} ->
        conn
        |> Plug.Conn.put_resp_content_type(MIME.from_path(desired_path))
        |> Plug.Conn.send_resp(200, content)

      {:error, :enoent} ->
        conn
        |> Plug.Conn.send_resp(404, "Not found")
    end
  end
end
