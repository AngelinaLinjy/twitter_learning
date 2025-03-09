defmodule Twitter.Repo.Migrations.RemovePostsSubject do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :subject
    end
  end
end
