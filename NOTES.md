## Update Elixir ENV
<!-- also consider:
mururu/exenv
taylor/kiex
asdf-vm/asdf - https://github.com/asdf-vm/asdf (only active development)

-->

```
exenv versions
exenv global 1.9.1
cd ~/.exenv
git pull

cd ~
exenv install 
```

## New Elixir Project 

```
<!-- update hex, simply run: -->
mix local.hex

mix new cards
cd cards
code -n .
mix test
mix get.deps
```

## Update Dependencies 

```
# https://hexdocs.pm/mix/master/Mix.html
mix hex.outdated
<!-- Shows all Hex dependencies that have newer versions in the registry. -->

mix deps.update 
<!-- will update your dependencies to the highest available version that matches your mix.exs requirements  -->

mix deps.get

mix deps.unlock some_dep
mix deps.get

Command line options
--all - updates all dependencies
--only - only fetches dependencies for given environment
--target - only fetches dependencies for given target
--no-archives-check - does not check archives before fetching deps
```

## New Pheonix Project

```
<!-- update pheonix code -->
mix archive.install hex phx_new 1.4.9

<!-- create project -->
mix phx.new discuss 
cd discuss/

<!-- start editor -->
code -n .

<!-- create db -->
mix ecto.create

<!-- Start your Phoenix app for web usage -->
mix phx.server
```

## PHOENIX BUILDING (Scaffolds)

```
<!-- You can also run your app inside IEx (Interactive Elixir) as: -->
iex -S mix phx.server


<!-- Like rails scaffold -->
mix phx.gen.html Web Todo todos description title:string

<!-- # create model and migration file -->
mix phx.gen.schema Topic topics title:string
mix ecto.migrate

<!-- # User migration file - no model -->
mix ecto.gen.migration update_topics_table
mix ecto.migrate


<!-- Create a controller in Phoenix -->
mix phx.gen.controller resource_name action
mix phx.gen.controller topic --crud
```

help
```
# https://hexdocs.pm/phoenix/phoenix_mix_tasks.html
mix help | grep -i phx
mix local.phx          # Updates the Phoenix project generator locally
mix phx                # Prints Phoenix help information
mix phx.digest         # Digests and compresses static files
mix phx.digest.clean   # Removes old versions of static assets.
mix phx.gen.cert       # Generates a self-signed certificate for HTTPS testing
mix phx.gen.channel    # Generates a Phoenix channel
mix phx.gen.context    # Generates a context with functions around an Ecto schema
mix phx.gen.embedded   # Generates an embedded Ecto schema file
mix phx.gen.html       # Generates controller, views, and context for an HTML resource
mix phx.gen.json       # Generates controller, views, and context for a JSON resource
mix phx.gen.presence   # Generates a Presence tracker
mix phx.gen.schema     # Generates an Ecto schema and migration file
mix phx.gen.secret     # Generates a secret
mix phx.new            # Creates a new Phoenix application
mix phx.new.ecto       # Creates a new Ecto project within an umbrella project
mix phx.new.web        # Creates a new Phoenix web project within an umbrella project
mix phx.routes         # Prints all routes
mix phx.server         # Starts applications and their servers
```

## PHOENIX CLI TESTING


```
<!-- See the routes -->
mix phx.routes

iex -S mix phx.server
iex -S mix phoenix.server

# https://hexdocs.pm/phoenix/views.html
DiscussWeb.PageView.render("index.html")
Phoenix.View.render(DiscussWeb.PageView, "index.html", %{})

# testing Topic Changeset 
struct = %Discuss.Topic{}
<!-- %Discuss.Topic{
  __meta__: #Ecto.Schema.Metadata<:built, "topics">,
  id: nil,
  inserted_at: nil,
  title: nil,
  updated_at: nil
} -->

params = %{title: "Great Balls of Fire"}
<!-- %{title: "Great Balls of Fire"} -->

Discuss.Topic.changeset(struct, params)
<!-- #Ecto.Changeset<
  action: nil,
  changes: %{title: "Great Balls of Fire"},
  errors: [],
  data: #Discuss.Topic<>,
  valid?: true
> -->

Discuss.Topic.changeset(struct, %{})
<!-- #Ecto.Changeset<
  action: nil,
  changes: %{},
  errors: [title: {"can't be blank", [validation: :required]}],
  data: #Discuss.Topic<>,
  valid?: false
> -->

```