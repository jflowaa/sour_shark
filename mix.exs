defmodule SourShark.MixProject do
  use Mix.Project

  def project do
    [
      app: :sour_shark,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {SourShark.Application, []}
    ]
  end

  defp deps do
    [
      {:websock_adapter, "~> 0.5.7"},
      {:file_system, "~> 1.0"},
      {:mdex, "~> 0.2.0"},
      {:bandit, "~> 1.0"}
    ]
  end
end
