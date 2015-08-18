defmodule Huebot.Plugins.Github.ListPullRequests do
  use GenEvent
  use Timex
  alias Huebot.MessageHandler

  @doc "Format: list prs ntxcode/huebot"
  @matcher ~r/(list|opened) (pull requests|prs) (?<repos>([a-zA-Z0-9-\/])+)/i

  def response(message, slack, state) do
    # Fetch all opened PRs
    client = Tentacat.Client.new(%{
      access_token: Application.get_env(:huebot, :github_token)
    })

    %{"repos" => repo_info} = Regex.named_captures(@matcher, message.text)

    [owner, repo] = String.split(repo_info, "/")

    Tentacat.Pulls.list(owner, repo, client)
    |> Enum.reduce("", fn (pull, acc) -> "#{acc}\n#{pull_row(pull)}" end)
  end

  # Handle the event of receiving a message
  def handle_event({:message, message, slack, slack_state}, state) do
    if Regex.match?(@matcher, message.text) do
      response(message, slack, slack_state)
      |> Slack.send_message(message.channel, slack)
    end

    {:ok, state}
  end

  defp pull_row(pull) do
    {:ok, created_at} = pull["created_at"]
                        |> Timex.DateFormat.parse("{ISO}")
    time_in_days_ago = Timex.Date.diff(created_at, Timex.Date.now, :days)

    "*#{pull["number"]}.* #{pull["title"]} - _#{time_in_days_ago} days ago_"
  end
end
