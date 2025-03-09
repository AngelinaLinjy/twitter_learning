defmodule TwitterWeb.PostLive.CommentFormComponent do
  use TwitterWeb, :live_component

  alias Twitter.Twitters
  alias Twitter.Twitters.Comment

  import Ecto.Changeset

  @impl true
  def render(assigns) do
    ~H"""
    <div class="border-t border-gray-800 pt-4">
      <.form
        for={@form}
        id="comment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="flex items-start space-x-3"
      >
        <img src={"/user/avatar/#{@current_user.id}"} alt="avatar" class="w-10 h-10 rounded-full" />
        <div class="flex-grow">
          <.input
            field={@form[:content]}
            type="textarea"
            placeholder="Post your reply"
            class="w-full bg-transparent border-none resize-none focus:ring-0 text-white placeholder-gray-500"
            rows="3"
          />
          <div class="flex justify-between items-center mt-2">
            <div class="flex space-x-2 text-blue-400">
              <button type="button" class="p-2 rounded-full hover:bg-blue-400 hover:bg-opacity-10">
                <svg viewBox="0 0 24 24" class="w-5 h-5 fill-current">
                  <path d="M3 5.5C3 4.119 4.119 3 5.5 3h13C19.881 3 21 4.119 21 5.5v13c0 1.381-1.119 2.5-2.5 2.5h-13C4.119 21 3 19.881 3 18.5v-13zM5.5 5c-.276 0-.5.224-.5.5v9.086l3-3 3 3 5-5 3 3V5.5c0-.276-.224-.5-.5-.5h-13zM19 15.414l-3-3-5 5-3-3-3 3V18.5c0 .276.224.5.5.5h13c.276 0 .5-.224.5-.5v-3.086zM9.75 7C8.784 7 8 7.784 8 8.75s.784 1.75 1.75 1.75 1.75-.784 1.75-1.75S10.716 7 9.75 7z">
                  </path>
                </svg>
              </button>
              <button type="button" class="p-2 rounded-full hover:bg-blue-400 hover:bg-opacity-10">
                <svg viewBox="0 0 24 24" class="w-5 h-5 fill-current">
                  <path d="M8 9.5C8 8.119 8.672 7 9.5 7S11 8.119 11 9.5 10.328 12 9.5 12 8 10.881 8 9.5zm6.5 2.5c.828 0 1.5-1.119 1.5-2.5S15.328 7 14.5 7 13 8.119 13 9.5s.672 2.5 1.5 2.5zM12 16c-2.224 0-3.021-2.227-3.051-2.316l-1.897.633c.05.15 1.271 3.684 4.949 3.684s4.898-3.533 4.949-3.684l-1.896-.638c-.033.095-.83 2.322-3.053 2.322zm10.25-4.001c0 5.652-4.598 10.25-10.25 10.25S1.75 17.652 1.75 12 6.348 1.75 12 1.75 22.25 6.348 22.25 12zm-2 0c0-4.549-3.701-8.25-8.25-8.25S3.75 7.451 3.75 12s3.701 8.25 8.25 8.25 8.25-3.701 8.25-8.25z">
                  </path>
                </svg>
              </button>
            </div>
            <.button
              phx-disable-with="Posting..."
              class="bg-blue-400 hover:bg-blue-500 text-white rounded-full px-4 py-2"
            >
              Reply
            </.button>
          </div>
        </div>
        <div class="hidden">
          <.input field={@form[:post_id]} type="text" value={@post_id} />
          <.input field={@form[:user_id]} type="text" value={@current_user.id} />
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{post: post, current_user: current_user} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:post_id, post.id)
     |> assign(:user_id, current_user.id)
     |> assign_new(:form, fn ->
       to_form(change(%Comment{}))
     end)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    changeset = Twitters.change_comment(%Comment{}, comment_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    save_comment(socket, socket.assigns.action, comment_params)
  end

  defp save_comment(socket, :comment, comment_params) do
    case Twitters.create_comment(comment_params) do
      {:ok, comment} ->
        notify_parent({:saved, comment})

        {:noreply,
         socket
         |> put_flash(:info, "Comments updated successfully")
         |> redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
