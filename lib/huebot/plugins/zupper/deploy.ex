defmodule Huebot.Plugins.Zupper.Deploy do
  use GenEvent
  import HTTPotion
  alias Huebot.MessageHandler

  @doc "Format: huebot deploy project (project) (tag)"
  @matcher ~r/huebot deploy (?<project>([a-zA-Z0-9-_\/])+) (?<tag>([a-zA-Z0-9-_\/])+)/i

  def response(message, slack, state) do
    %{"project" => project_name, "tag" => tag} = Regex.named_captures(@matcher, message.text)

    zupper_json = %{
      "project_name" => project_name,
      "branch" => tag
    } |> Poison.encode!

    hook_url = Application.get_env(:huebot, :zupper_hook_url)

    HTTPotion.post(hook_url,
      [
        body: zupper_json,
        headers: ["Content-Type": "application/json"],
        stream_to: self,
        timeout: 200_000
      ]
    )

    "Sir yes sir! Sent the deploy command to your Zupper server."
  end

  # Handle the event of receiving a message
  def handle_event({:message, message, slack, slack_state}, state) do
    if Regex.match?(@matcher, message.text) do
      response(message, slack, slack_state)
      |> Slack.send_message(message.channel, slack)
    end

    {:ok, state}
  end
end
