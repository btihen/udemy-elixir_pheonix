defmodule Discuss.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(topic, attrs\\%{}) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
  # def changeset(struct, params \\ %{}) do
  #   struct
  #   |> cast(params, [:title])
  #   |> validate_required([:title])
  # end

end