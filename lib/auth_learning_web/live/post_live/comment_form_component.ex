defmodule AuthLearningWeb.PostLive.CommentFormComponent do
  use AuthLearningWeb, :live_component

  alias AuthLearning.Twitters
  alias AuthLearning.Twitters.Comment

  import Ecto.Changeset

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-black text-white">
      <.header>
        <%= @title %>
        <:subtitle>Leave the comment!</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="comment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:content]} type="text" label="Comment" />
        <div class="hidden">
          <.input field={@form[:post_id]} type="text" value={@post_id} />
          <.input field={@form[:user_id]} type="text" value={@post.user.id} />
        </div>
        <:actions>
          <.button phx-disable-with="Saving...">Save Comment</.button>
        </:actions>
      </.simple_form>
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
         |> redirect(to: "/posts")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
