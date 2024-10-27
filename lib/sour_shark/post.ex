defmodule SourShark.Blog.Post do
  @enforce_keys [:id, :title, :category, :body, :description, :tags, :date, :path]
  defstruct [:id, :title, :category, :body, :description, :tags, :date, :path]

  def build(filename, attrs, body) do
    path =
      filename
      |> String.replace("priv/", "")
      |> String.replace(".md", ".html")

    [year, month_day_id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    struct!(
      __MODULE__,
      [id: id, date: date, body: body, path: path] ++ Map.to_list(attrs)
    )
  end
end
