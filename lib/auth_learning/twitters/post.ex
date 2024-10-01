defmodule AuthLearning.Twitters.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :subject, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:subject, :body])
    |> validate_required([:subject, :body])
  end
end
