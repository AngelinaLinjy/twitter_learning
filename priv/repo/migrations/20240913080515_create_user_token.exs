defmodule AuthLearning.Repo.Migrations.CreateUserToken do
  use Ecto.Migration

  def change do
    create table(:user_tokens) do
      add :token, :binary
      add :context, :string
      timestamps(type: :utc_datetime)
    end
  end
end
