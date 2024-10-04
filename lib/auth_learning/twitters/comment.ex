defmodule AuthLearning.Twitters.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias AuthLearning.Account.User
  alias AuthLearning.Twitters.Post

  @required_fields [:content, :post_id, :user_id]

  schema "comments" do
    field :content, :string
    belongs_to :post, Post
    belongs_to :user, User, foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
