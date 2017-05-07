defmodule Issues.GitHubIssues do
  @github_url Application.get_env(:issues, :github_url)
  @user_agent [ { "User-agent", "Elixir matt.fehskens@gmail.com" } ]

  def fetch(user, project) do
    issues_url(user, project)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end

  def issues_url(user, project) do
    "#{ @github_url }/repos/#{ user }/#{ project }/issues"
  end

  def handle_response({ :ok, %{ status_code: 200, body: body } }) do
    { :ok, Poison.Parse.parse!(body) }
  end

  def handle_response({ _, %{ status_code: _, body: body } }) do
    { :error, Poison.Parse.parse!(body) }
  end
end