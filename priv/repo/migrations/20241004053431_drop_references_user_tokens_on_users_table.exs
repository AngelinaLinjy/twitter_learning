defmodule AuthLearning.Repo.Migrations.DropReferencesUserTokensOnUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :user_token_id, references(:user_tokens)
    end
  end
end
