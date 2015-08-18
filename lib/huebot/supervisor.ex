defmodule Huebot.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @message_handler_name Huebot.MessageHandler
  @plugin_manager_name Huebot.PluginManager

  def init(:ok) do
    children = [
      worker(@message_handler_name, [Application.get_env(:huebot, :slack_token), [name: @message_handler_name]]),
      worker(@plugin_manager_name, [])
    ]

    IO.puts "Starting supervisor..."

    supervise(children, strategy: :one_for_one)
  end
end
