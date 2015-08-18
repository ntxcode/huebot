defmodule Huebot.PluginManager do
  @event_server_name PluginEventServer

  def start_link do
    GenEvent.start_link([name: @event_server_name])

    # Add all plugins as handlers for the event
    plugins = Application.get_env(:huebot, :plugins)
              |> Enum.each(
                fn (plugin) ->
                  GenEvent.add_handler(@event_server_name, plugin, [])
                end)

    {:ok, self}
  end

  # Broadcast message to all plugins
  def broadcast_message(message, slack, state) do
    GenEvent.notify(@event_server_name, {:message, message, slack, state})
  end
end

