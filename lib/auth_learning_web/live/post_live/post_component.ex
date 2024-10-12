defmodule AuthLearningWeb.PostLive.PostComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="tweet flex">
      <img src="" alt="avatar" class="avatar" />
      <div class="w-full">
        <div class="tweet-header">
          <strong>@<%= @post.user.name %></strong>
          <span class="tweet-timestamp"><%= format_timestamp(@post.inserted_at) %></span>
        </div>

        <div class="tweet-body" phx-click="body" phx-target={@myself}>
          <p><%= @post.body %></p>
        </div>
        <div class="tweet-footer">
          <button phx-click="like">❤️ Like</button>
          <%!-- <span><%= @post.likes_count %> Likes</span> --%>
          <button phx-click="retweet">🔁 Retweet</button>
          <button phx-click="edit">✏️ Edit</button>
          <button phx-click="delete">🚮 Delete</button>
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
end
