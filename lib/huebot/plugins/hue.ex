defmodule Huebot.Plugins.Hue do
  alias Huebot.Plugin

  @matcher ~r/hue(( )+)?hue/i

  def response(message_received, slack, state) do
    image_link = [
      "http://d.pr/i/12Nqk+",
      "http://d.pr/i/16VJs+",
      "http://d.pr/i/1138F+"
    ] |> Enum.shuffle |> hd

    "THIS IS HUE. #{image_link}"
  end

  def parse(message, slack, state) do
    response(message, slack, state)
    |> Plugin.parse(@matcher, message, slack, state)
  end
end
