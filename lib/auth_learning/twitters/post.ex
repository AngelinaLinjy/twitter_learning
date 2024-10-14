defmodule AuthLearning.Twitters.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias AuthLearning.Account.User
  alias AuthLearning.Twitters.Comment
  alias AuthLearning.Twitters.Like

  @required_fields [:body, :user_id]

  schema "posts" do
    field :body, :string
    belongs_to :user, User, foreign_key: :user_id
    has_many :comment, Comment, on_delete: :delete_all
    has_many :like, Like, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields ++ [:user_id])
  end
end
