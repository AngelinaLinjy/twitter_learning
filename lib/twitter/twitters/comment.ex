defmodule Twitter.Twitters.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitter.Account.User
  alias Twitter.Twitters.Post

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
