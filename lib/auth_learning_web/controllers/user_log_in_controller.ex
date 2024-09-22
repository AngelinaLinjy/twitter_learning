defmodule AuthLearningWeb.UserLogInController do
  use AuthLearningWeb, :controller

  alias AuthLearning.UserAccount

  def new(conn, _params) do
    render(conn, :new)
  end

  def log_in(conn, %{"user" => %{"email" => email, "password" => password}} = _params) do
    case UserAccount.get_user_by_email_and_password(email, password) do
      nil ->
        conn
        |> put_flash(:error, "Failed to log in user.")
        |> redirect(to: "/user/log_in")

      _user ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: "/")
    end
  end
end
