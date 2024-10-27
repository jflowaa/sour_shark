defmodule SourShark.Blog do
  alias SourShark.Blog.Post
  alias SourShark.MarkdownConverter

  use NimblePublisher,
    build: Post,
    from: "priv/posts/**/*.md",
    html_converter: MarkdownConverter,
    as: :posts

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  def all_posts, do: @posts

  def all_development_posts,
    do: Enum.filter(all_posts(), &(&1.category == :development))
end
