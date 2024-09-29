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

  def verify(conn, %{"token" => token} = params) do
    {:ok, decoded_token} = Base.url_decode64(token, padding: false)

    case UserAccount.verify_user_by_reset_token(decoded_token) do
      user ->
        conn
        |> put_flash(:info, "Hi, #{user.name}, please reset password.")
        |> redirect(to: "/user/reset_password")

      _ ->
        conn
        |> put_flash(:error, "Something wrong with verify reset token!")
        |> redirect(to: "/")
    end
  end

  defp validate(password, confirmation) do
    password == confirmation || {:error, "Passwords do not match。"}
  end
end
