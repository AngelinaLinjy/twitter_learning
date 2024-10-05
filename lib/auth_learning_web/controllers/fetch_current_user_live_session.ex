defmodule AuthLearningWeb.FetchCurrentUserLiveSession do
  # import Phoenix.LiveView
  import Phoenix.Component

  alias AuthLearning.UserAccount

  def on_mount(:fetch_current_user, _params, session, socket) do
    {:cont, assign(socket, :current_user, fetch_current_user(session))}
  end

  defp fetch_current_user(session) do
    token = Map.get(session, "user_token")
    %AuthLearning.Account.User{} = user = UserAccount.verify_user_by_session_token(token)
    user
  end
end
