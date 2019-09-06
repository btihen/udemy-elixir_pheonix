defmodule DiscussWeb.Plugs.RequireSignIn do
  import Plug.Conn
  import Phoenix.Controller

  alias DiscussWeb.Router.Helpers

  def init(_params) do
  end

  # https://whatdidilearn.info/2018/02/25/phoenix-authentication-and-authorization-using-plugs.html
  def call(conn, _params) do
    if conn.assigns.user_signed_in? do
      conn
    else
      conn
      |> put_flash(:error, "You need to sign in before continuing.")
      |> redirect(to: Helpers.topic_path(conn, :index))
      # |> redirect(to: Helpers.auth_path(conn, :request, "github"))
      |> halt()
    end
  end

end
