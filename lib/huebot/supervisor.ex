defmodule Huebot.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @message_handler_name Huebot.MessageHandler

  def init(:ok) do
    children = []

    IO.puts "Slack token: #{Application.get_env(:huebot, :slack_token)}"
    Huebot.MessageHandler.start_link(Application.get_env(:huebot, :slack_token), [])
    supervise(children, strategy: :one_for_one)
  end
end
