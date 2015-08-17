require IEx
defmodule Huebot.MessageHandler do
  use Slack

  def init(initial_state, slack) do
    {:ok, initial_state}
  end

  def handle_message(message = %{type: "message", subtype: _}, _slack, state) do
    {:ok, state}
  end

  def handle_message(message = %{type: "message"}, slack, state) do
    # Sends the message to all registered plugins
    IO.puts "Message received: #{message.text}"

    plugins = Application.get_env(:huebot, :plugins)
              |> Enum.each(fn (plugin) ->
                 send_message_to_plugin(plugin, message, slack, state)
              end)

    {:ok, state}
  end

  def handle_message(_message, _slack, state) do
    {:ok, state}
  end

  defp send_message_to_plugin(plugin, message, slack, state) do
    IO.puts "Plugin is parsing..."

    response = plugin.parse(message, slack, state)

    IO.puts "Response: #{response}"

    if response != nil do
      send_message(response, message.channel, slack)
    end
  end
end

