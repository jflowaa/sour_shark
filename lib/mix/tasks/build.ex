defmodule Mix.Tasks.Build do
  import EEx
  use Mix.Task
  @impl Mix.Task

  @output_dir "./output"
  @highlight_js_version "11.9.0"
  @highlight_js_cdn "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/#{@highlight_js_version}"
  @highlight_js_languages ["elixir", "bash", "yaml", "json", "csharp"]

  @shortdoc "Creates all the static files for the site"
  def run(_args) do
    {micro, _} =
      :timer.tc(fn ->
        clean_output_dir()
        download_highlight_js_assets()
        build_pages()
        build_blog()
        build_assets()
      end)

    ms = micro / 1000
    IO.puts("Finished building site in #{ms}ms")
  end

  defp clean_output_dir() do
    IO.puts("Cleaning output directory")
    {_, exit_status} = System.cmd("rm", ["-rf", @output_dir])
    if exit_status != 0, do: raise("Failed to clean output directory")
  end

  defp download_highlight_js_assets() do
    IO.puts("Downloading highlight.js assets")
    {_, exit_status} = System.cmd("mkdir", ["-p", "#{@output_dir}/js/languages"])
    if exit_status != 0, do: raise("Failed to create directories for highlight.js assets")

    {highlight_js_output, highlight_js_exit_status} =
      System.cmd("wget", ["-P", "#{@output_dir}/js", "#{@highlight_js_cdn}/highlight.min.js"])

    if highlight_js_exit_status != 0 do
      raise("Failed to download highlight.js: #{highlight_js_output}")
    end

    Enum.each(@highlight_js_languages, fn lang ->
      {lang_output, lang_exit_status} =
        System.cmd("wget", [
          "-P",
          "#{@output_dir}/js/languages",
          "#{@highlight_js_cdn}/languages/#{lang}.min.js"
        ])

      if lang_exit_status != 0 do
        raise("Failed to download highlight.js language #{lang}: #{lang_output}")
      end
    end)
  end

  defp build_pages() do
    for source <- Path.wildcard("lib/sour_shark/templates/pages/*.html.eex") do
      target = source |> Path.basename() |> String.replace(".eex", "")
      IO.puts("Building #{source} -> #{target}")

      File.write!(
        "#{@output_dir}/#{target}",
        eval_file("lib/sour_shark/templates/root.html.eex",
          assigns: [extra_head: nil, content: eval_file(source, assigns: [])]
        )
      )
    end
  end

  defp build_blog() do
    posts = SourShark.Blog.all_posts()

    extra_head =
      eval_file("lib/sour_shark/templates/blog_head.html.eex",
        assigns: [languages: @highlight_js_languages]
      )

    for post <- posts do
      if Path.dirname(post.path) != ".",
        do: File.mkdir_p!(Path.join([@output_dir, Path.dirname(post.path)]))

      IO.puts("Building #{post.path}")

      File.write!(
        "#{@output_dir}/#{post.path}",
        eval_file("lib/sour_shark/templates/root.html.eex",
          assigns: [
            extra_head: extra_head,
            content: "<article class=\"prose dark:prose-invert\">#{post.body}</article>"
          ]
        )
      )
    end
  end

  defp build_assets() do
    IO.puts("Building assets")
    {_, exit_status} = System.cmd("mkdir", ["-p", "#{@output_dir}/css"])
    if exit_status != 0, do: IO.puts("Failed to create CSS directory")

    for asset <- Path.wildcard("priv/static/**/*.{js,txt,ico}") do
      IO.puts("Copying #{asset}")
      File.cp!(asset, "#{@output_dir}/#{String.replace(asset, "priv/static/", "")}")
    end

    IO.puts("Building Tailwind CSS")

    {output, exit_status} =
      System.cmd("sh", ["-c", "source ./tailwind/build_css.sh"], stderr_to_stdout: false)

    if exit_status != 0 do
      raise("Failed to build Tailwind CSS: #{output}")
    end
  end
end
