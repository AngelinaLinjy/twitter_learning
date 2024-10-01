defmodule AuthLearning.Twitters.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias AuthLearning.Account.User

  @required_fields [:subject, :body]

  schema "posts" do
    field :body, :string
    field :subject, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @required_fields)
    |> cast_assoc(:user)
    |> validate_required(@required_fields ++ [:user])
  end
end
