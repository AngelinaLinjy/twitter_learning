defmodule TwitterWeb.FetchCurrentUserLiveSession do
  # import Phoenix.LiveView
  import Phoenix.Component

  alias Twitter.UserAccount

  def on_mount(:fetch_current_user, _params, session, socket) do
    {:cont, assign(socket, :current_user, fetch_current_user(session))}
  end

  defp fetch_current_user(session) do
    token = Map.get(session, "user_token")
    %Twitter.Account.User{} = user = UserAccount.verify_user_by_session_token(token)
    user
  end
end
