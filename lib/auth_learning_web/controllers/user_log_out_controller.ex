defmodule AuthLearningWeb.UserLogOutController do
  use AuthLearningWeb, :controller

  def log_out(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> clear_session()
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: ~p"/user/log_in")
  end
end
