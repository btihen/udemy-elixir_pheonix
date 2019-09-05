defmodule DiscussWeb.Router do
  use DiscussWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", DiscussWeb do
    pipe_through :browser  # pre-processing

    # /auth/github (uses strategy patter to pick provider)
    get "/:provider", AuthController, :request  # predefined by oauth
    # /auth/github/callback
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", DiscussWeb do
    pipe_through :browser

    get "/", PageController, :index
    # resources "/", TopicController

    resources "/topics", TopicController
    # resources "/topics", TopicController, except: [:delete]
    # get "/topics/new", TopicController, :new
    # post "/topics", TopicController, :create
    # get "/topics/", TopicController, :index
    # get "/topics/:id/edit", TopicController, :edit
    # put "/topics/:id", TopicController, :update
    # get "/topics/:id", TopicController, :show
    # delete "/topics/:id", TopicController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", DiscussWeb do
  #   pipe_through :api
  # end
end
