defmodule AuthLearningWeb.UserAuth do
  use AuthLearningWeb, :controller

  alias AuthLearning.UserAccount

  import Plug.Conn

  def fetch_current_user(conn, _opts) do
    token = get_session(conn, :user_token)

    case UserAccount.get_user_by_session_token(token) do
      %AuthLearning.Account.User{} = user ->
        conn
        |> assign(:current_user, user.email)

      _ ->
        conn
        |> assign(:current_user, nil)

        # |> maybe_store_return_to()
    end
  end

  def require_authenticated_user(conn, _opts) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> redirect(to: "/user/log_in")

      _user ->
        conn
    end
  end
end
