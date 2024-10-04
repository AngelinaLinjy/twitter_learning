defmodule AuthLearningWeb.UserProfileLive.Index do
  use AuthLearningWeb, :live_view

  alias AuthLearning.UserAccount

  @impl true
  def mount(%{"id" => user_id}, _session, socket) do
    user = UserAccount.get!(user_id)
    followings = UserAccount.user_followings(user_id)
    followers = UserAccount.user_followers(user_id)

    {:ok,
     socket
     |> assign(:followings, followings)
     |> assign(:followers, followers)
     |> assign(:user, user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, %{"id" => id}) do
    socket
    |> assign(:page_title, "Profile")
    |> assign(:user, UserAccount.get!(id))
  end
end
