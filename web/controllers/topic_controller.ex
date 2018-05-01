defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  def index(conn, _params) do
    query = from topic in Topic,
      select: topic.title
    IO.inspect(Repo.all(query))
    render conn, "index.html", topics: Repo.all(query)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)
    case Repo.insert(changeset) do
      {:ok, post} ->
        render conn, "success.html"
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end
end
