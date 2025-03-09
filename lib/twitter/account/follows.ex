defmodule Twitter.Account.Follows do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitter.Account.User

  @required_fields [:follower_id, :followed_id]

  schema "follows" do
    belongs_to :follower, User
    belongs_to :followed, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:follower_id, :followed_id])
  end
end
