defmodule AuthLearning.UserAccount do
  alias AuthLearning.Account.User
  alias AuthLearning.Repo
  alias AuthLearning.Account.UserToken

  import Ecto.Query

  @rand_size 32
  @log_in_session_token "log_in_session_token"

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

  def gen_log_in_session_token(user_id) do
    token = :crypto.strong_rand_bytes(@rand_size)
    user = Repo.get(User, user_id)

    token = %UserToken{token: token, context: @log_in_session_token, user_id: user.id}

    token
    |> Repo.insert(conflict_target: [:context, :user_id], on_conflict: {:replace, [:token]})
  end

  def get_user_by_session_token(token) do
    token =
      UserToken
      |> where([t], t.token == ^token)
      |> Repo.one()

    user = Repo.get(User, token.user_id)
  end
end
