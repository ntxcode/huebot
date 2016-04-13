defmodule Huebot.Plugins.Gitlab.TriggerBuild do
  require IEx
  use GenEvent
  use Timex
  alias Huebot.MessageHandler

  @doc "Format: huebot trigger (repo) (branch)"
  @matcher ~r/huebot trigger (?<repo>([a-zA-Z0-9-\/])+) (?<branch>([a-zA-Z0-9-\.])+)/i

  def response(message, slack, state) do
    %{"repo" => repo, "branch" => branch} = Regex.named_captures(@matcher, message.text)

    gitlab_private_token = Application.get_env(:huebot, :gitlab_private_token)
    api_url = Application.get_env(:huebot, :gitlab_api_url)

    # Fetch all projects
    projects = HTTPotion.get("#{api_url}/projects?per_page=200",
      [
        headers: [
          "Content-Type": "application/json",
          "PRIVATE-TOKEN": gitlab_private_token
        ],
        timeout: 200_000
      ]
    )

    # Find project
    project = projects.body
              |> Poison.decode!
              |> find_project(repo)

    if project do
      # Fetch project triggers
      project_id = project["id"]

      # Fetch all project's triggers
      triggers = HTTPotion.get("#{api_url}/projects/#{project_id}/triggers",
        [
          headers: [
            "Content-Type": "application/json",
            "PRIVATE-TOKEN": gitlab_private_token
          ],
          timeout: 200_000
        ]
      )

      # Find first trigger
      trigger = triggers.body
                |> Poison.decode!
                |> Enum.at(0)

      if trigger do
        response = HTTPotion.post("#{api_url}/projects/#{project_id}/trigger/builds",
          [
            body: "token=#{trigger["token"]}&ref=#{branch}",
            headers: ["Content-Type": "application/x-www-form-urlencoded"],
            timeout: 200_000,
            stream_to: self
          ]
        )

        "Triggered build for *#{repo}:#{branch}*. :+1:"
      else
        "Project *#{repo}* doesn't have any trigger registered. Please register at least one."
      end
    else
      "Project *#{repo}* not found, check your spelling"
    end
  end

  # Handle the event of receiving a message
  def handle_event({:message, message, slack, slack_state}, state) do
    if Regex.match?(@matcher, message.text) do
      response(message, slack, slack_state)
      |> Slack.send_message(message.channel, slack)
    end

    {:ok, state}
  end

  defp find_project(projects, repo) do
    projects |> Enum.find(nil, fn(project) -> project["path_with_namespace"] == repo end)
  end
end
