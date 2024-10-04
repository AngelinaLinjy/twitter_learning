defmodule AuthLearning.Repo.Migrations.PostsUsersAssociation do
  use Ecto.Migration

  def change do
    alter table("posts") do
      add :user_id, references(:users)
    end

    alter table("users") do
      add :post_id, references(:posts)
    end
  end
end
