defmodule AuthLearningWeb.UserProfileLive.Index do
  use AuthLearningWeb, :live_view

  alias AuthLearning.UserAccount
  alias AuthLearning.Twitters

  @impl true
  def mount(%{"id" => user_id}, _session, socket) do
    user = UserAccount.get!(user_id)
    followings_count = UserAccount.user_followings(user_id)
    followers_count = UserAccount.user_followers(user_id)
    posts = Twitters.list_user_posts(user_id)

    {:ok,
     socket
     |> assign(:followings_count, followings_count)
     |> assign(:followers_count, followers_count)
     |> assign(:user, user)
     |> assign(:follows, [])
     |> assign(:show_follows, false)
     |> assign(:show_edit_profile, false)
     |> assign(:user_form, to_form(UserAccount.change_user(user)))
     |> assign(:active_tab, "posts")
     |> assign(:posts, posts)
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 1,
       max_file_size: 5_000_000
     )}
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
  def handle_event("follow", _params, socket) do
    case UserAccount.create_following(socket.assigns.current_user.id, socket.assigns.user.id) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Follow user successfully!")
          |> assign(:followers_count, socket.assigns.followers_count + 1)

        {:noreply, socket}

      _ ->
        socket =
          socket
          |> put_flash(:error, "Failed to follow user!")

        {:noreply, socket}
    end
  end

  def handle_event("click-following", _params, socket) do
    follows = UserAccount.fetch_following_list(socket.assigns.user.id)

    {:noreply, socket |> assign(:show_follows, "Following") |> assign(:follows, follows)}
  end

  def handle_event("click-follower", _params, socket) do
    follows = UserAccount.fetch_follower_list(socket.assigns.user.id)

    {:noreply, socket |> assign(:show_follows, "Follower") |> assign(:follows, follows)}
  end

  def handle_event("close-follows", _params, socket) do
    {:noreply, socket |> assign(:show_follows, false) |> assign(:follows, [])}
  end

  def handle_event("open-edit-profile", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_edit_profile, true)}
  end

  def handle_event("close-edit-profile", _params, socket) do
    {:noreply, assign(socket, :show_edit_profile, false)}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    user = socket.assigns.user

    user_params =
      case consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
             File.read(path)
           end) do
        [avatar_binary] ->
          user_params |> Map.put("avatar", avatar_binary)

        _ ->
          user_params
      end

    IO.inspect(user_params, label: "asdfasdfasdf")

    {:ok, user} = UserAccount.update(user, user_params)

    {:noreply, socket |> assign(:user, user) |> assign(:show_edit_profile, false)}
  end

  def handle_event("change-tab", %{"tab" => tab}, socket) do
    case tab do
      "posts" ->
        posts = Twitters.list_user_posts(socket.assigns.user.id)
        {:noreply, socket |> assign(:active_tab, tab) |> assign(:posts, posts)}

      "media" ->
        {:noreply, socket |> assign(:active_tab, tab)}

      _ ->
        {:noreply, socket |> assign(:active_tab, tab)}
    end
  end

  defp is_following?(follower_id, followed_id) do
    UserAccount.is_following?(follower_id, followed_id)
  end
end
