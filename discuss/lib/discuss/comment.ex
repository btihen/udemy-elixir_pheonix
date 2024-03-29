defmodule Discuss.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:content]}

  schema "comments" do
    field :content, :string

    belongs_to(:user, Discuss.User)
    belongs_to(:topic, Discuss.Topic)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content, :topic_id])
    # |> validate_required([:content, :topic_id, :user_id])
  end
end
