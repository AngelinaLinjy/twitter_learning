defmodule Twitter.Repo.Migrations.AddIndexUserUserToken do
  use Ecto.Migration

  def change do
    create index("user_tokens", [:token], unique: true)
    create index("users", [:email], unique: true)
  end
end
