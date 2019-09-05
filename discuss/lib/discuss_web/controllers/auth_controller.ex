defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.User
  alias Discuss.Repo

  # may not be necessary
  # alias Ueberauth.Strategy.Helpers

  # default works fine too
  # def request(conn, _params) do
  #   render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  # end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    # IO.puts "++++++++"
    # IO.inspect auth
    # IO.puts "++++++++"
    # IO.inspect _params
    # IO.puts "++++++++"
    # get users email & token from auth
    user_params = %{token: auth.credentials.token,
                    email: auth.info.email,
                    provider: "github"}
    changeset   = User.changeset(%User{}, user_params)
    sign_in(conn, changeset)
  end

  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successful login.")
        |> put_session(:user_id, user.id)
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "OOOPS - something went wrong :(")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    user = Repo.get_by(User, email: changeset.changes.email)
    case user do
      (%User{} = user) -> {:ok, user}
      _                -> Repo.insert(changeset)
      # Repo.insert(changeset) -- returns either
      # {:ok, user} (just like our retieved user)
      # {error: changset}
    end
  end

end

# IO.inspect auth
# %Ueberauth.Auth{
#   credentials: %Ueberauth.Auth.Credentials{
#     expires: false,
#     expires_at: nil,
#     other: %{},
#     refresh_token: nil,
#     scopes: [""],
#     secret: nil,
#     token: "c0fa5ee64600b9489a6b8473fcea68da542ff5bd",
#     token_type: "Bearer"
#   },
#   extra: %Ueberauth.Auth.Extra{
#     raw_info: %{
#       token: %OAuth2.AccessToken{
#         access_token: "c0fa5ee64600b9489a6b8473fcea68da542ff5bd",
#         expires_at: nil,
#         other_params: %{"scope" => ""},
#         refresh_token: nil,
#         token_type: "Bearer"
#       },
#       user: %{
#         "avatar_url" => "https://avatars1.githubusercontent.com/u/57390?v=4",
#         "bio" => nil,
#         "blog" => "",
#         "company" => nil,
#         "created_at" => "2009-02-24T07:19:00Z",
#         "email" => "btihen@gmail.com",
#         "events_url" => "https://api.github.com/users/btihen/events{/privacy}",
#         "followers" => 8,
#         "followers_url" => "https://api.github.com/users/btihen/followers",
#         "following" => 9,
#         "following_url" => "https://api.github.com/users/btihen/following{/other_user}",
#         "gists_url" => "https://api.github.com/users/btihen/gists{/gist_id}",
#         "gravatar_id" => "",
#         "hireable" => nil,
#         "html_url" => "https://github.com/btihen",
#         "id" => 57390,
#         "location" => nil,
#         "login" => "btihen",
#         "name" => nil,
#         "node_id" => "MDQ6VXNlcjU3Mzkw",
#         "organizations_url" => "https://api.github.com/users/btihen/orgs",
#         "public_gists" => 9,
#         "public_repos" => 56,
#         "received_events_url" => "https://api.github.com/users/btihen/received_events",
#         "repos_url" => "https://api.github.com/users/btihen/repos",
#         "site_admin" => false,
#         "starred_url" => "https://api.github.com/users/btihen/starred{/owner}{/repo}",
#         "subscriptions_url" => "https://api.github.com/users/btihen/subscriptions",
#         "type" => "User",
#         "updated_at" => "2019-09-04T17:36:15Z",
#         "url" => "https://api.github.com/users/btihen"
#       }
#     }
#   },
#   info: %Ueberauth.Auth.Info{
#     description: nil,
#     email: "btihen@gmail.com",
#     first_name: nil,
#     image: "https://avatars1.githubusercontent.com/u/57390?v=4",
#     last_name: nil,
#     location: nil,
#     name: nil,
#     nickname: "btihen",
#     phone: nil,
#     urls: %{
#       api_url: "https://api.github.com/users/btihen",
#       avatar_url: "https://avatars1.githubusercontent.com/u/57390?v=4",
#       blog: "",
#       events_url: "https://api.github.com/users/btihen/events{/privacy}",
#       followers_url: "https://api.github.com/users/btihen/followers",
#       following_url: "https://api.github.com/users/btihen/following{/other_user}",
#       gists_url: "https://api.github.com/users/btihen/gists{/gist_id}",
#       html_url: "https://github.com/btihen",
#       organizations_url: "https://api.github.com/users/btihen/orgs",
#       received_events_url: "https://api.github.com/users/btihen/received_events",
#       repos_url: "https://api.github.com/users/btihen/repos",
#       starred_url: "https://api.github.com/users/btihen/starred{/owner}{/repo}",
#       subscriptions_url: "https://api.github.com/users/btihen/subscriptions"
#     }
#   },
#   provider: :github,
#   strategy: Ueberauth.Strategy.Github,
#   uid: 57390
# }
