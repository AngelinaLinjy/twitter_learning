defmodule TwitterWeb.PostLive.Index do
  use TwitterWeb, :live_view

  alias Twitter.Twitters
  alias Twitter.Twitters.Post
  alias Twitter.UserAccount
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(Twitter.PubSub, "new_post")
    {:ok, stream(socket, :posts, Twitters.list_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("cancel", _, socket) do
    {:noreply, redirect(socket, to: ~p"/posts")}
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
    |> assign(:page_title, "Home")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({TwitterWeb.PostLive.CommentFormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end

  def handle_info({:new_post, post}, socket) do
    {:noreply,
     socket |> put_flash(:info, "New post by #{post.user.name}, the subject is: #{post.body}!")}
  end
end
