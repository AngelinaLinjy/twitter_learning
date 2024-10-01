defmodule AuthLearning.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias AuthLearning.Account.UserToken
  alias AuthLearning.Twitters.Post

  @required_fields [:name, :email, :password]

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    has_many :user_tokens, UserToken
    has_many :posts, Post

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
