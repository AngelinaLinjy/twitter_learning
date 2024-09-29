defmodule AuthLearningWeb.UserResetPasswordController do
  use AuthLearningWeb, :controller

  alias AuthLearning.UserAccount
  alias AuthLearning.Account.User

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(
        conn,
        %{
          "user" => %{
            "email" => email,
            "password" => password,
            "password_confirmation" => password_confirmation
          }
        } = _params
      ) do
    with true <- validate(password, password_confirmation),
         %User{} = user <- UserAccount.get_user_by_email(email),
         {:ok, _} <-
           UserAccount.update(user, %{password: password}) do
      conn
      |> put_flash(:info, "The password has been reset successfully!")
      |> redirect(to: "/user/log_in")
    else
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: "/user/reset_password")

      _ ->
        conn
        |> put_flash(:error, "Unknown error")
        |> redirect(to: "/user/reset_password")
    end
  end

  defp validate(password, confirmation) do
    password == confirmation || {:error, "Passwords do not match。"}
  end
end
