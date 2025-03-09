defmodule Twitter.Repo.Migrations.AddImageToPosts do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:avatar, :binary)
    end
  end
end
