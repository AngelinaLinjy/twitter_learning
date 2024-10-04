defmodule AuthLearningWeb.PostLive.Index do
  use AuthLearningWeb, :live_view

  alias AuthLearning.Twitters
  alias AuthLearning.Twitters.Post
  alias AuthLearning.UserAccount

  @impl true
  def mount(_params, session, socket) do
    current_user = fetch_current_user(session)

    {:ok, stream(socket, :posts, Twitters.list_posts()) |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Twitters.get_post!(id))
  end

  defp apply_action(socket, :comment, %{"id" => id}) do
    socket
    |> assign(:page_title, "Comment Post")
    |> assign(:post, Twitters.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({AuthLearningWeb.PostLive.CommentFormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Twitters.get_post!(id)
    {:ok, _} = Twitters.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end

  defp fetch_current_user(session) do
    token = Map.get(session, "user_token")

    %AuthLearning.Account.User{} = user = UserAccount.verify_user_by_session_token(token)
    user
  end
end
