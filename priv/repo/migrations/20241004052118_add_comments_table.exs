defmodule Twitter.Repo.Migrations.AddCommentsTable do
  use Ecto.Migration

  def change do
    create table("comments") do
      add :content, :string
      add :post_id, references("posts")
      add :user_id, references("users")

      timestamps(type: :utc_datetime)
    end
  end
end
