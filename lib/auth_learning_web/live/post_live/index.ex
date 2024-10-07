defmodule AuthLearningWeb.PostLive.Index do
  use AuthLearningWeb, :live_view

  alias AuthLearning.Twitters
  alias AuthLearning.Twitters.Post
  alias AuthLearning.UserAccount
  alias Phoenix.PubSub

  @impl true
  def mount(_params, session, socket) do
    PubSub.subscribe(AuthLearning.PubSub, "new_post")
    {:ok, stream(socket, :posts, Twitters.list_posts())}
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

  def handle_info({:new_post, post}, socket) do
    {:noreply,
     socket |> put_flash(:info, "New post by #{post.user.name}, the subject is: #{post.subject}!")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Twitters.get_post!(id)
    {:ok, _} = Twitters.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end
end
