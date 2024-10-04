defmodule AuthLearning.Account.Follows do
  use Ecto.Schema
  import Ecto.Changeset

  alias AuthLearning.Account.User

  @required_fields [:follower_id, :followed]

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
  end
end
