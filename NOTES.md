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

<!-- You can also run your app inside IEx (Interactive Elixir) as: -->
iex -S mix phx.server

<!-- # User migration file -->
mix phx.gen.schema Auth.User users name:string email:string password_hash:string is_admin:boolean
<!-- # Posts migration file -->
mix phx.gen.schema Content.Post posts title:string body:text published:boolean cover:string user_id:integer slug:string

```