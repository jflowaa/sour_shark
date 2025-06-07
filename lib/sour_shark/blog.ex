defmodule SourShark.Blog do
  alias SourShark.Blog.Post

  @blog_base_path "priv/posts"

  def build_posts do
    Path.wildcard(Path.join(@blog_base_path, "**/*.md"))
    |> Enum.map(fn path ->
      content = File.read!(path)
      [metadata, body | _rest] = String.split(content, "---", parts: 2)

      date =
        case Regex.run(~r/(\d{4})\/(\d{2})-(\d{2})-/, path) do
          [_, year, month, day] ->
            Date.new!(String.to_integer(year), String.to_integer(month), String.to_integer(day))

          _ ->
            nil
        end

      metadata
      |> Code.eval_string()
      |> elem(0)
      |> Map.put(
        :body,
        MDEx.to_html!(body,
          render: [
            escape: false,
            unsafe: true
          ]
        )
      )
      |> Map.put(:path, path |> String.replace_suffix(".md", ".html"))
      |> Map.put(:date, date)
      |> then(&struct(Post, &1))
    end)
  end
end
