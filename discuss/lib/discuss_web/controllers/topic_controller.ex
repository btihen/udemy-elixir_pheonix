defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Topic
  alias Discuss.Repo

  import Ecto.Query

  def index(conn, _params) do
    # query  = from Topic
    # topics = Repo.all(query)
    topics = Repo.all(Topic)
    # IO.inspect topics
    render(conn, "index.html", topics: topics)
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    render(conn, "show.html", topic: topic)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    # %{"title" => title} = topic
    changeset = Topic.changeset(%Topic{}, topic)
    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Created successfully.")
        |> redirect(to: Routes.topic_path(conn, :index))        # render(conn, "index.html", topics: title)
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end

  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic} = params) do
    # %{"title" => title} = topic
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)
    # changeset =
    #   Repo.get(Topic, topic_id)
    #   |> Topic.changeset(topic)
    case Repo.update(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Updated successfully.")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: old_topic)
    end

  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.delete(Topic, topic_id)
    conn
    |> put_flash(:info, "Updated successfully.")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

end
