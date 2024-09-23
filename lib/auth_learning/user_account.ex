defmodule AuthLearning.UserAccount do
  alias AuthLearning.Account.User
  alias AuthLearning.Repo

  import Ecto.Query

  def get_user_by_email_and_password(email, password) do
    User
    |> where(email: ^email, password: ^password)
    |> Repo.one()
  end

  def registrate_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
