defmodule Twitter.Repo.Migrations.AddUniqueIndexUserTokens do
  use Ecto.Migration

  def change do
    create unique_index(:user_tokens, [:user_id, :context])
  end
end
