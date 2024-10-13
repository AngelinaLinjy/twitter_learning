defmodule AuthLearningWeb.UserAvatarController do
  use AuthLearningWeb, :controller

  alias AuthLearning.UserAccount

  def index(conn, %{"id" => id}) do
    user = UserAccount.get!(id)

    conn
    |> put_resp_content_type("image/jpeg")
    |> send_resp(200, user.avatar || "")
  end
end
