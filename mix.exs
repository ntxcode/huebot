defmodule Huebot.Mixfile do
  use Mix.Project

  def project do
    [app: :huebot,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod: {Huebot, []},
      applications: [:logger, :slack, :httpotion]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:httpotion, "~> 2.1.0"},
      {:slack, "~> 0.2.0"},
      {:websocket_client, git: "https://github.com/jeremyong/websocket_client"},
      {:tentacat, github: "estevaoam/tentacat", branch: "update-httpoison-version"},
      {:timex, "~> 0.19.0"},
      {:poison, "~> 1.5"}
    ]
  end
end
