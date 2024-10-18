defmodule AuthLearningWeb.PostLive.FormComponent do
  use AuthLearningWeb, :live_component

  alias AuthLearning.Twitters
  alias AuthLearning.Twitters.Post

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-black text-white p-4 rounded-xl">
      <.simple_form
        for={@form}
        id="post-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-4"
      >
        <div class="flex items-start space-x-4">
          <img src={"/user/avatar/#{@current_user.id}"} alt="avatar" class="w-12 h-12 rounded-full" />
          <div class="flex-grow">
            <.input
              field={@form[:body]}
              type="textarea"
              placeholder="What's happening?"
              rows="4"
              class="w-full bg-transparent border-none text-xl focus:ring-0 placeholder-gray-500"
            />
          </div>
        </div>
        <div class="flex justify-between items-center">
          <div class="flex space-x-4 text-blue-400">
            <button type="button" class="hover:bg-blue-900 rounded-full p-2">
              <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M3 5.5C3 4.119 4.119 3 5.5 3h13C19.881 3 21 4.119 21 5.5v13c0 1.381-1.119 2.5-2.5 2.5h-13C4.119 21 3 19.881 3 18.5v-13zM5.5 5c-.276 0-.5.224-.5.5v9.086l3-3 3 3 5-5 3 3V5.5c0-.276-.224-.5-.5-.5h-13zM19 15.414l-3-3-5 5-3-3-3 3V18.5c0 .276.224.5.5.5h13c.276 0 .5-.224.5-.5v-3.086zM9.75 7C8.784 7 8 7.784 8 8.75s.784 1.75 1.75 1.75 1.75-.784 1.75-1.75S10.716 7 9.75 7z">
                </path>
              </svg>
            </button>
            <button type="button" class="hover:bg-blue-900 rounded-full p-2">
              <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M3 5.5C3 4.119 4.12 3 5.5 3h13C19.88 3 21 4.119 21 5.5v13c0 1.381-1.12 2.5-2.5 2.5h-13C4.12 21 3 19.881 3 18.5v-13zM5.5 5c-.28 0-.5.224-.5.5v13c0 .276.22.5.5.5h13c.28 0 .5-.224.5-.5v-13c0-.276-.22-.5-.5-.5h-13zM18 10.711V9.25h-3.74v5.5h1.44v-1.719h1.7V11.57h-1.7v-.859H18zM11.79 9.25h1.44v5.5h-1.44v-5.5zm-3.07 1.375c.34 0 .77.172 1.02.43l1.03-.86c-.51-.601-1.28-.945-2.05-.945C7.19 9.25 6 10.453 6 12s1.19 2.75 2.72 2.75c.85 0 1.54-.344 2.05-.945v-2.149H8.38v1.032H9.4v.515c-.17.086-.42.172-.68.172-.76 0-1.36-.602-1.36-1.375 0-.688.6-1.375 1.36-1.375z">
                </path>
              </svg>
            </button>
          </div>
          <.button
            phx-disable-with="Posting..."
            class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded-full"
          >
            Post
          </.button>
        </div>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{post: post} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Twitters.change_post(post))
     end)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset = Twitters.change_post(socket.assigns.post, post_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    save_post(socket, socket.assigns.action, post_params)
  end

  defp save_post(socket, :edit, post_params) do
    case Twitters.update_post(socket.assigns.post, post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_post(socket, :new, post_params) do
    current_user_id = socket.assigns.current_user.id
    post_params = Map.put(post_params, "user_id", current_user_id)

    case Twitters.create_post(post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_patch(to: socket.assigns.patch)
         |> assign(:form, %Post{})}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
