defmodule Huebot.MessageHandler do
  use Slack
  alias Huebot.PluginManager

  def init(initial_state, slack) do
    {:ok, initial_state}
  end

  def handle_message(message = %{type: "message", subtype: _}, _slack, state) do
    {:ok, state}
  end

  def handle_message(message = %{type: "message"}, slack, state) do
    # Sends the message to all registered plugins
    IO.puts "Message received: #{message.text}"

    # Notifies the PluginHandler, that'll broadcast the message
    # event to all plugin custom handlers.
    PluginManager.broadcast_message(message, slack, state)

    {:ok, state}
  end

  def handle_message(_message, _slack, state) do
    {:ok, state}
  end
end

