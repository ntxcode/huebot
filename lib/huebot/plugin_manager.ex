defmodule Huebot.PluginManager do
  def start_link do
    GenEvent.start_link([name: Huebot.PluginManager])

    # Add all plugins as handlers for the event
    plugins = Application.get_env(:huebot, :plugins)
              |> Enum.each(
                fn (plugin) ->
                  GenEvent.add_handler(Huebot.PluginManager, plugin, [])
                end)

    {:ok, self}
  end

  # Broadcast message to all plugins
  def broadcast_message(message, slack, state) do
    GenEvent.notify(Huebot.PluginManager, {:message, message, slack, state})
  end
end
