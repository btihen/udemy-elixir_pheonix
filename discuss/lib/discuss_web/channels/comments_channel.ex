defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias Discuss.{Topic, Comment}
  # first time connect
  # pattern match on string
  def join(("comments:" <> topic_id_str) = name, _auth_params, socket) do
    # IO.puts "++++++++++++"
    # IO.inspect name
    # IO.puts "++++++++++++"

    topic_id = String.to_integer(topic_id_str)
    # topic    = Discuss.Repo.get(Topic, topic_id)
    topic = Topic
            |> Discuss.Repo.get(topic_id)
            |> Discuss.Repo.preload(:comments)
            # |> Enum.sort_by(& &1.inserted_at)

    title    = topic.title
    comments = topic.comments
              #  |> Enum.sort_by(&(&1.updated_at < &2.updated_at))
    # https://elixirforum.com/t/how-to-sort-list-of-structs-based-on-value-in-stucts/17798
    # https://stackoverflow.com/questions/51758710/how-can-i-sort-list-of-map-by-map-value-in-elixir
    # sorted   = Enum.sort(topic.comments,
    #                      fn x, y ->
    #                         case Date.compare(x.datetime, y.datetime) do
    #                           :lt -> true
    #                           _ -> false
    #                         end
    #                       end
    #                     )
    # IO.puts "++++++++++++"
    # IO.inspect title
    # IO.puts "++++++++++++"
    IO.puts "++++++++++++"
    IO.inspect comments
    IO.puts "++++++++++++"
    # IO.puts "++++++++++++"
    # IO.inspect sorted
    # IO.puts "++++++++++++"

    socket = socket
              |> assign(:topic, topic)
              |> assign(:topic_id, topic_id)
              # |> assign(:user, user)
              # |> assign(:user_id, user_id)

    {:ok, %{comments: comments}, socket}
    # {:ok, %{title: title}, assign(socket, :topic, topic)}
  end
  # def join(name, _auth_params, socket) do
  #   IO.puts "++++++++++++"
  #   IO.inspect name
  #   IO.puts "++++++++++++"
  #   {:ok, %{hey: "there"}, socket}
  # end

  # handle ongoing communication
  def handle_in(name, %{"content" => content} = message, socket) do
    topic = socket.assigns.topic

    # IO.puts "++++++++++++"
    # IO.inspect name
    # IO.inspect topic
    # IO.inspect socket
    # IO.inspect content
    # IO.inspect message
    # IO.puts "++++++++++++"

    changeset = topic
                # |> Ecto.build_assoc(:users)
                |> Ecto.build_assoc(:comments)
                |> Discuss.Comment.changeset(%{content: content})
    case Discuss.Repo.insert(changeset) do
      {:ok, comment}   ->
        broadcast!(socket,
                   "comments:#{socket.assigns.topic_id}:new",
                   %{comment: comment})
        {:reply, :ok, socket}
      {:error, _reason} -> {:reply, {:error, %{errors: changeset}}, socket}
    end
    # {:reply, :ok, socket}
  end

end
