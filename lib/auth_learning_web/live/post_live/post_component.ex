defmodule AuthLearningWeb.PostLive.PostComponent do
  use AuthLearningWeb, :live_component

  alias AuthLearning.Twitters
  alias AuthLearning.Twitters.Post
  alias AuthLearning.Account.User
  alias AuthLearning.UserAccount

  def render(assigns) do
    ~H"""
    <div id={"post-#{@post.id}"} class="tweet flex p-4">
      <img src={"/user/avatar/#{@post.user.id}"} alt="avatar" class="avatar" />
      <div class="w-full">
        <div class="tweet-header">
          <strong>@<%= @post.user.name %></strong>
          <span class="tweet-timestamp"><%= format_timestamp(@post.inserted_at) %></span>
        </div>

        <div class="tweet-body" phx-click="body" phx-target={@myself}>
          <p><%= @post.body %></p>
        </div>
        <div class="tweet-footer">
          <%= if UserAccount.liked?(@current_user.id, @post.id) do %>
            <button phx-click="unlike" phx-target={@myself}>
              ❤️ Unlike <%= count_likes(@post.id) %>
            </button>
          <% else %>
            <button phx-click="like" phx-target={@myself}>❤️ Like <%= count_likes(@post.id) %></button>
          <% end %>

          <button phx-click="retweet">🔁 Retweet</button>
          <%= if @current_user.id == @post.user.id do %>
            <.link patch={~p"/posts/#{@post.id}/edit"}>✏️ Edit</.link>
          <% else %>
            <.link patch={~p"/posts/#{@post.id}/comment"}>📝 Comment</.link>
          <% end %>
          <%= if @current_user.id == @post.user.id do %>
            <.link
              phx-click={JS.push("delete", value: %{id: @post.id}) |> hide("##{@post.id}")}
              phx-target={@myself}
              data-confirm="Are you sure?"
            >
              🚮 Delete
            </.link>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  @impl
  def handle_event("body", _params, socket) do
    socket =
      socket
      |> redirect(to: "/posts/#{socket.assigns.post.id}")

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    post = Twitters.get_post!(id)
    {:ok, _} = Twitters.delete_post(post)

    {:noreply, socket |> redirect(to: "/")}
  end

  def handle_event(
        "like",
        _params,
        %{assigns: %{post: %Post{id: post_id}, current_user: %User{id: current_user_id}}} = socket
      ) do
    case Twitters.create_like(%{post_id: post_id, user_id: current_user_id}) do
      {:ok, _} ->
        post = Twitters.get_post!(post_id)

        {:noreply,
         socket
         |> put_flash(:info, "Add like successfully!")
         |> redirect(to: "/")}

      _ ->
        {:noreply, socket |> put_flash(:error, "failed to like")}
    end
  end

  def handle_event(
        "unlike",
        _params,
        %{assigns: %{post: %Post{id: post_id}, current_user: %User{id: current_user_id}}} = socket
      ) do
    case Twitters.delete_like(%{post_id: post_id, user_id: current_user_id}) do
      {:ok, _} ->
        post = Twitters.get_post!(post_id)

        {:noreply,
         socket
         |> put_flash(:info, "Unlike successfully!")
         |> redirect(to: "/")}

      _ ->
        {:noreply, socket |> put_flash(:error, "failed to unlike")}
    end
  end

  defp format_timestamp(timestamp) do
    current_time = DateTime.utc_now()
    elapsed_time = DateTime.diff(current_time, timestamp)

    cond do
      elapsed_time < 60 ->
        "#{elapsed_time} second#{if elapsed_time != 1, do: "s"} ago"

      elapsed_time < 3600 ->
        minutes = div(elapsed_time, 60)
        "#{minutes} minute#{if minutes != 1, do: "s"} ago"

      elapsed_time < 86400 ->
        hours = div(elapsed_time, 3600)
        "#{hours} hour#{if hours != 1, do: "s"} ago"

      true ->
        days = div(elapsed_time, 86400)
        "#{days} day#{if days != 1, do: "s"} ago"
    end
  end

  defp count_likes(post_id) do
    Twitters.count_likes(post_id)
  end
end
