defmodule AuthLearning.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias AuthLearning.Account.UserToken
  alias AuthLearning.Twitters.Post
  alias AuthLearning.Twitters.Comment
  alias AuthLearning.Account.Follows
  alias AuthLearning.Account.User

  @required_fields [:name, :email, :password]

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :avatar, :string
    has_many :user_tokens, UserToken
    has_many :posts, Post
    has_many :comment, Comment

    many_to_many :followings, User,
      join_through: Follows,
      join_keys: [follower_id: :id, followed_id: :id]

    many_to_many :followers, User,
      join_through: Follows,
      join_keys: [followed_id: :id, follower_id: :id]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ [:avatar])
    |> validate_required(@required_fields)
    |> unique_constraint([:email])
  end
end
