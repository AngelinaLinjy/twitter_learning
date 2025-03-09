defmodule TwitterWeb.UserAvatarController do
  use TwitterWeb, :controller

  alias Twitter.UserAccount

  def index(conn, %{"id" => id}) do
    user = UserAccount.get!(id)

    conn
    |> put_resp_content_type("image/jpeg")
    |> send_resp(200, user.avatar || "")
  end
end
