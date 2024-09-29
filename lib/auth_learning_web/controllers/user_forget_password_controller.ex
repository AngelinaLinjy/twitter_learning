defmodule AuthLearningWeb.UserForgetPasswordController do
  use AuthLearningWeb, :controller

  alias AuthLearning.UserAccount
  alias AuthLearning.Account.UserToken
  alias AuthLearning.UserNotifier

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = UserAccount.get_user_by_email(email) do
      {:ok, %UserToken{token: token} = _user_token} = UserAccount.gen_reset_password_token(user)

      encoded_token = Base.url_encode64(token, padding: false)

      url = "/user/reset_password/#{encoded_token}"

      UserNotifier.deliver_reset_password_instructions(user, url)

      conn
      |> put_flash(:info, "Please check your email and reset password via url sent to you.")
    else
      conn
      |> put_flash(:error, "The email is not valid.")
      |> redirect(to: "/user/forget_password")
    end
  end
end
