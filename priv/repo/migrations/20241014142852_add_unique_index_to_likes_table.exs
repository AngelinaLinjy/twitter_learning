defmodule AuthLearning.Repo.Migrations.AddUniqueIndexToLikesTable do
  use Ecto.Migration

  def change do
    create unique_index("likes", [:post_id, :user_id])
  end
end
