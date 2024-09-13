defmodule AuthLearning.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias AuthLearning.Account.UserTokens

  @required_fields [:name, :email, :password]

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    has_many :user_tokens, UserTokens, foreign_key: :user_token_id, references: :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:email])
  end
end
