defmodule DiscussWeb.Plugs.SetCurrentUser do
  import Plug.Conn
  # import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  def init(_params) do
  end

  # https://whatdidilearn.info/2018/02/25/phoenix-authentication-and-authorization-using-plugs.html
  def call(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :user_id)

    cond do
      current_user = user_id && Repo.get(User, user_id) ->
        conn
        |> assign(:user, current_user)
        |> assign(:current_user, current_user)
        |> assign(:user_signed_in?, true)
      true ->
        conn
        |> assign(:user, nil)
        |> assign(:current_user, nil)
        |> assign(:user_signed_in?, false)
    end
  end
  # # params is the return from init (good for expensive operations)
  # def call(conn, _params) do
  #   user_id = Plug.Conn.get_session(conn, :user_id)
  #   cond do
  #     user = user_id && Repo.get(User, user_id) ->
  #       assign(conn, :user, user)
  #       # get using: conn.assigns.user => user stuct
  #     true ->
  #       assign(conn, :user, nil)
  #   end
  # end

end
