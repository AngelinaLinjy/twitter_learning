defmodule AuthLearning.Repo.Migrations.RemoveReferencesOfPostIdOnUsersTable do
  use Ecto.Migration

  def change do
    alter table("users") do
      remove :post_id
    end
  end
end
