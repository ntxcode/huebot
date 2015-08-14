defmodule Huebot do
  use Application

  def start(_type, _args) do
    Huebot.Supervisor.start_link()
  end
end
