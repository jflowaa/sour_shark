defmodule SourShark.MarkdownConverter do
  def convert(filepath, body, _attrs, _opts) do
    if Path.extname(filepath) in [".md", ".markdown"] do
      body |> MDEx.to_html!(render: [unsafe_: true])
    end
  end
end
