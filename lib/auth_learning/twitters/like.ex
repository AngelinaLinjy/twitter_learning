defmodule AuthLearning.Twitters.Like do
  use Ecto.Schema
  import Ecto.Changeset

  alias AuthLearning.Twitters.Post
  alias AuthLearning.Account.User

  schema "likes" do
    belongs_to :post, Post
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:post_id])
    |> validate_required([:post_id])
    |> unique_constraint([:post_id, :user_id])
  end
end
