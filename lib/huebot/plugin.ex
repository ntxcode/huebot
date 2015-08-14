defmodule Huebot.Plugin do
  def parse(response, matcher, message, slack, state) do
    if Regex.match?(matcher, message.text) do
      response
    else
      nil
    end
  end
end

