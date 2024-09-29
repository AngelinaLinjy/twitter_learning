defmodule AuthLearningWeb.UserLogInController do
  use AuthLearningWeb, :controller

  alias AuthLearning.UserAccount
  alias AuthLearning.Account.UserToken

  def new(conn, _params) do
    render(conn, :new)
  end

  def log_in(conn, %{"user" => %{"email" => email, "password" => password}} = _params) do
    with user when not is_nil(user) <-
           UserAccount.get_user_by_email_and_password(email, password),
         {:ok, %UserToken{token: token}} <- UserAccount.gen_log_in_session_token(user) do
      conn
      |> put_flash(:info, "Welcome back!")
      |> put_session(:user_token, token)
      |> redirect(to: "/")
    else
      _ ->
        conn
        |> put_flash(:error, "Failed to log in user.")
        |> redirect(to: "/user/log_in")
    end
  end
end
