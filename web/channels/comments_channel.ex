defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel

  alias Discuss.Topic
  alias Discuss.Comment

  def join("comments:" <> topic_id, _params, socket) do
    IO.inspect(socket)
    topic_id = String.to_integer(topic_id)
    topic = Repo.get(Topic, topic_id)
    {:ok, %{name: topic.title}, assign(socket, :topic, topic)}
  end

  def handle_in(name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    changeset = topic
    |> build_assoc(:comments)
    |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

end
