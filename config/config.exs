# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config
alias Huebot.Plugins

config :huebot, :slack_token, System.get_env("SLACK_BOT_TOKEN")
config :huebot, :github_token, System.get_env("GITHUB_ACCESS_TOKEN")
config :huebot, :zupper_hook_url, System.get_env("ZUPPER_HOOK_URL")
config :huebot, :gitlab_private_token, System.get_env("GITLAB_PRIVATE_TOKEN")
config :huebot, :gitlab_api_url, System.get_env("GITLAB_API_URL")

config :huebot, :plugins, [
  Plugins.Hue,
  Plugins.Github.ListPullRequests,
  Plugins.Zupper.Deploy,
  Plugins.Gitlab.TriggerBuild
]

# config :logger, :handle_otp_reports, true
# config :logger, :handle_sasl_reports, true

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for third-
# party users, it should be done in your mix.exs file.

# Sample configuration:
#
config :logger, :console,
  level: :info,
  format: "$date $time [$level] $metadata$message\n",
  metadata: [:user_id]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
