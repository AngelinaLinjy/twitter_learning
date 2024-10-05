defmodule AuthLearningWeb.UserProfileLive.Index do
  use AuthLearningWeb, :live_view

  alias Hex.API.User
  alias AuthLearning.UserAccount

  @impl true
  def mount(%{"id" => user_id}, _session, socket) do
    user = UserAccount.get!(user_id)
    followings_count = UserAccount.user_followings(user_id)
    followers_count = UserAccount.user_followers(user_id)

    {:ok,
     socket
     |> assign(:followings_count, followings_count)
     |> assign(:followers_count, followers_count)
     |> assign(:user, user)
     |> assign(:follows, [])
     |> assign(:show_follows, false)}
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

  @impl true
  def handle_event("follow", params, socket) do
    case UserAccount.create_following(socket.assigns.current_user.id, socket.assigns.user.id) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Follow user successfully!")

        {:noreply, socket}

      _ ->
        socket =
          socket
          |> put_flash(:error, "Failed to follow user!")

        {:noreply, socket}
    end
  end

  def handle_event("click-following", params, socket) do
    follows = UserAccount.fetch_following_list(socket.assigns.user.id)

    {:noreply, socket |> assign(:show_follows, "Following") |> assign(:follows, follows)}
  end

  def handle_event("click-follower", params, socket) do
    follows = UserAccount.fetch_follower_list(socket.assigns.user.id)

    {:noreply, socket |> assign(:show_follows, "Follower") |> assign(:follows, follows)}
  end

  defp is_following?(follower_id, followed_id) do
    UserAccount.is_following?(follower_id, followed_id)
  end
end
