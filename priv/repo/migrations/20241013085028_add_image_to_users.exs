defmodule AuthLearning.Repo.Migrations.AddImageToPosts do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:avator, :string)
    end
  end
end
