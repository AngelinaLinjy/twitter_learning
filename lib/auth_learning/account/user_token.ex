defmodule AuthLearning.Account.UserToken do
  use Ecto.Schema
  import Ecto.Changeset

  alias AuthLearning.Account.User

  @required_fields [:token, :context]

  schema "user_tokens" do
    field :token, :string
    field :context, :string
    belongs_to :user, User, foreign_key: :user_id, references: :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_token, attrs) do
    user_token
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:token])
  end
end
