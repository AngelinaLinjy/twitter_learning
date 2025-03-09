defmodule Twitter.Twitters.Like do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitter.Twitters.Post
  alias Twitter.Account.User

  schema "likes" do
    belongs_to :post, Post
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:post_id, :user_id])
    |> validate_required([:post_id, :user_id])
    |> unique_constraint([:post_id, :user_id])
  end
end
