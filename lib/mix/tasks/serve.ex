defmodule Mix.Tasks.Serve do
  use Mix.Task
  @impl Mix.Task

  @output_dir "./output"
  File.mkdir_p!(@output_dir)

  def run(_args) do
    Application.start(:inets)

    # TODO: doesn't work as desired, use `mix run --no-halt`
    :inets.start(:httpd,
      port: 8000,
      server_root: ~c".",
      document_root: @output_dir,
      server_name: ~c"localhost",
      mime_types: [
        {~c"html", ~c"text/html"},
        {~c"htm", ~c"text/html"},
        {~c"js", ~c"text/javascript"},
        {~c"css", ~c"text/css"},
        {~c"gif", ~c"image/gif"},
        {~c"jpg", ~c"image/jpeg"},
        {~c"jpeg", ~c"image/jpeg"},
        {~c"png", ~c"image/png"}
      ]
    )
  end
end
