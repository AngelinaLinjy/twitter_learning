defmodule AuthLearningWeb.PostLive.PostComponent do
  use AuthLearningWeb, :live_component

  alias AuthLearning.Twitters
  alias AuthLearning.Twitters.Post
  alias AuthLearning.Account.User
  alias AuthLearning.UserAccount

  def render(assigns) do
    ~H"""
    <div
      id={"post-#{@post.id}"}
      class="border-b border-gray-800 p-4 hover:bg-gray-900/50 transition duration-200 cursor-pointer"
    >
      <div class="flex">
        <div class="flex-shrink-0 mr-3">
          <.link navigate={~p"/user_profile/#{@post.user.id}"}>
            <img src={"/user/avatar/#{@post.user.id}"} alt="avatar" class="w-12 h-12 rounded-full" />
          </.link>
        </div>
        <div class="flex-grow">
          <div class="flex items-center mb-1">
            <span class="font-bold text-white"><%= @post.user.name %></span>
            <span class="text-gray-500 mx-1">·</span>
            <span class="text-gray-500"><%= format_timestamp(@post.inserted_at) %></span>
          </div>
          <div class="mb-2 text-white" phx-click="body" phx-target={@myself}>
            <%= @post.body %>
          </div>
          <div class="flex justify-between text-gray-500 max-w-md">
            <button class="flex items-center hover:text-blue-400 transition duration-200">
              <svg viewBox="0 0 24 24" class="w-5 h-5 mr-2 fill-current">
                <g>
                  <path d="M1.751 10c0-4.42 3.584-8 8.005-8h4.366c4.49 0 8.129 3.64 8.129 8.13 0 2.96-1.607 5.68-4.196 7.11l-8.054 4.46v-3.69h-.067c-4.49.1-8.183-3.51-8.183-8.01zm8.005-6c-3.317 0-6.005 2.69-6.005 6 0 3.37 2.77 6.08 6.138 6.01l.351-.01h1.761v2.3l5.087-2.81c1.951-1.08 3.163-3.13 3.163-5.36 0-3.39-2.744-6.13-6.129-6.13H9.756z">
                  </path>
                </g>
              </svg>
              <%!-- <%= count_comments(@post.id) %> --%> 999
            </button>
            <button class="flex items-center hover:text-green-400 transition duration-200">
              <svg viewBox="0 0 24 24" class="w-5 h-5 mr-2 fill-current">
                <g>
                  <path d="M4.5 3.88l4.432 4.14-1.364 1.46L5.5 7.55V16c0 1.1.896 2 2 2H13v2H7.5c-2.209 0-4-1.79-4-4V7.55L1.432 9.48.068 8.02 4.5 3.88zM16.5 6H11V4h5.5c2.209 0 4 1.79 4 4v8.45l2.068-1.93 1.364 1.46-4.432 4.14-4.432-4.14 1.364-1.46 2.068 1.93V8c0-1.1-.896-2-2-2z">
                  </path>
                </g>
              </svg>
              <%!-- <%= count_retweets(@post.id) %> --%> 999
            </button>
            <button
              class="flex items-center transition duration-200 group"
              phx-click={
                if UserAccount.liked?(@current_user.id, @post.id), do: "unlike", else: "like"
              }
              phx-target={@myself}
            >
              <div class="relative">
                <svg
                  viewBox="0 0 24 24"
                  class={
                    "w-5 h-5 mr-2 transition-all duration-300 ease-out #{
                      if UserAccount.liked?(@current_user.id, @post.id),
                        do: "text-pink-600",
                        else: "text-gray-500 group-hover:text-pink-600"
                    }"
                  }
                >
                  <path
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    d="M12 21.638h-.014C9.403 21.59 1.95 14.856 1.95 8.478c0-3.064 2.525-5.754 5.403-5.754 2.29 0 3.83 1.58 4.646 2.73.814-1.148 2.354-2.73 4.645-2.73 2.88 0 5.404 2.69 5.404 5.755 0 6.376-7.454 13.11-10.037 13.157H12z"
                  />
                </svg>
                <div class={
                  "absolute inset-0 transition-all duration-300 #{
                    if UserAccount.liked?(@current_user.id, @post.id),
                      do: "opacity-100 scale-100",
                      else: "opacity-0 scale-0"
                  }"
                }>
                  <svg viewBox="0 0 24 24" class="w-5 h-5 text-pink-600 fill-current">
                    <path d="M12 21.638h-.014C9.403 21.59 1.95 14.856 1.95 8.478c0-3.064 2.525-5.754 5.403-5.754 2.29 0 3.83 1.58 4.646 2.73.814-1.148 2.354-2.73 4.645-2.73 2.88 0 5.404 2.69 5.404 5.755 0 6.376-7.454 13.11-10.037 13.157H12z" />
                  </svg>
                  <div class="absolute inset-0 animate-heart-burst">
                    <div class="absolute inset-0 opacity-0 animate-sparkle">
                      <svg viewBox="0 0 24 24" class="w-5 h-5 text-pink-300 fill-current">
                        <circle cx="12" cy="12" r="1" />
                        <circle cx="8" cy="9" r="1" />
                        <circle cx="16" cy="9" r="1" />
                        <circle cx="8" cy="15" r="1" />
                        <circle cx="16" cy="15" r="1" />
                      </svg>
                    </div>
                  </div>
                </div>
              </div>
              <span class={
                "transition-colors duration-300 #{
                  if UserAccount.liked?(@current_user.id, @post.id),
                    do: "text-pink-600",
                    else: "text-gray-500 group-hover:text-pink-600"
                }"
              }>
                <%= count_likes(@post.id) %>
              </span>
            </button>
            <%= if @current_user.id == @post.user.id do %>
              <button
                class="flex items-center hover:text-red-500 transition duration-200"
                phx-click={JS.push("delete", value: %{id: @post.id}) |> hide("##{@post.id}")}
                phx-target={@myself}
                data-confirm="Are you sure?"
              >
                <svg viewBox="0 0 24 24" class="w-5 h-5 mr-2 fill-current">
                  <g>
                    <path d="M16 6V4.5C16 3.12 14.88 2 13.5 2h-3C9.11 2 8 3.12 8 4.5V6H3v2h1.06l.81 11.21C4.98 20.78 6.28 22 7.86 22h8.27c1.58 0 2.88-1.22 3-2.79L19.93 8H21V6h-5zm-6-1.5c0-.28.22-.5.5-.5h3c.27 0 .5.22.5.5V6h-4V4.5zm7.13 14.57c-.04.52-.47.93-1 .93H7.86c-.53 0-.96-.41-1-.93L6.07 8h11.85l-.79 11.07zM9 17v-6h2v6H9zm4 0v-6h2v6h-2z">
                    </path>
                  </g>
                </svg>
              </button>
            <% else %>
              <button class="flex items-center hover:text-blue-400 transition duration-200">
                <svg viewBox="0 0 24 24" class="w-5 h-5 mr-2 fill-current">
                  <g>
                    <path d="M17 4c-1.1 0-2 .9-2 2 0 .33.08.65.22.92C15.56 7.56 16.23 8 17 8c1.1 0 2-.9 2-2s-.9-2-2-2zm-4 2c0-2.21 1.79-4 4-4s4 1.79 4 4-1.79 4-4 4c-1.17 0-2.22-.5-2.95-1.3l-4.16 2.37c.07.3.11.61.11.93s-.04.63-.11.93l4.16 2.37c.73-.8 1.78-1.3 2.95-1.3 2.21 0 4 1.79 4 4s-1.79 4-4 4-4-1.79-4-4c0-.32.04-.63.11-.93L8.95 14.7C8.22 15.5 7.17 16 6 16c-2.21 0-4-1.79-4-4s1.79-4 4-4c1.17 0 2.22.5 2.95 1.3l4.16-2.37c-.07-.3-.11-.61-.11-.93z">
                    </path>
                  </g>
                </svg>
              </button>
            <% end %>
          </div>
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
