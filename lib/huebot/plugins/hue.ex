defmodule Huebot.Plugins.Hue do
  use GenEvent
  alias Huebot.MessageHandler

  @matcher ~r/hue(( )+)?hue/i

  # Handle the event of receiving a message
  def handle_event({:message, message, slack, slack_state}, state) do
    if Regex.match?(@matcher, message.text) do
      response(message, slack, slack_state)
      |> Slack.send_message(message.channel, slack)
    end

    {:ok, state}
  end

  defp response(message_received, slack, state) do
    image_link = [
      "http://d.pr/i/12Nqk+",
      "http://d.pr/i/16VJs+",
      "http://d.pr/i/1138F+"
    ] |> Enum.shuffle |> hd

    "THIS IS HUE. #{image_link}"
  end
end
