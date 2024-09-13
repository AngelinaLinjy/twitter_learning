defmodule AuthLearning.Repo.Migrations.AddAssociationUserUserToken do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :user_token_id, references(:user_tokens)
    end

    alter table(:user_tokens) do
      add :user_id, references(:users)
    end
  end
end
