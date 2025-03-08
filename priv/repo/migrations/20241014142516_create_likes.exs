defmodule Twitter.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :post_id, references(:posts)
      add :user_id, references(:users)

      timestamps(type: :utc_datetime)
    end
  end
end
