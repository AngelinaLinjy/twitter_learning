defmodule Twitter.Repo.Migrations.AddFollowsTable do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :follower_id, references(:users)
      add :followed_id, references(:users)

      timestamps()
    end

    create unique_index(:follows, [:follower_id, :followed_id])
  end
end
