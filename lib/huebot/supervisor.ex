defmodule Huebot.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @message_handler_name Huebot.MessageHandler

  def init(:ok) do
    children = [
      worker(@message_handler_name, [Application.get_env(:huebot, :slack_token), [name: @message_handler_name]])
    ]

    IO.puts "Starting supervisor access..."
    supervise(children, strategy: :one_for_one)
  end
end
