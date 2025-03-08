defmodule TwitterWeb.UserAuth do
  use TwitterWeb, :controller

  alias Twitter.UserAccount

  import Plug.Conn

  def fetch_current_user(conn, _opts) do
    token = get_session(conn, :user_token)

    case UserAccount.verify_user_by_session_token(token) do
      nil ->
        conn
        |> assign(:current_user, nil)

      %Twitter.Account.User{} = user ->
        conn
        |> assign(:current_user, user)
    end
  end

  def require_authenticated_user(conn, _opts) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> put_flash(:error, "Your log in token expired. Please re-log in.")
        |> redirect(to: "/user/log_in")

      _user ->
        conn
    end
  end
end
