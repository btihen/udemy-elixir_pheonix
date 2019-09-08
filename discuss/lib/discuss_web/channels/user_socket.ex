defmodule DiscussWeb.UserSocket do
  use Phoenix.Socket

  # kind of like a router file
  channel "comments:*", DiscussWeb.CommentsChannel

  # default (outdated) -- other options exist
  # transport :websocket, Phoenix.Transport.WebSockets


  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

   # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
