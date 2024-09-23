defmodule AuthLearningWeb.UserRegistrationController do
  use AuthLearningWeb, :controller

  alias AuthLearning.UserAccount

  def index(conn, _params) do
    render(conn, :index)
  end

  def create(conn, %{"user" => user} = _params) do
    case UserAccount.registrate_user(key_to_atom(user)) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Registrated the account successfully!")
        |> redirect(to: "/")

      _ ->
        conn
        |> put_flash(:error, "Failed to registrating user.")
        |> redirect(to: "/user/registration")
    end
  end

  defp key_to_atom(map) do
    map
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put(acc, to_atom(k), v)
    end)
    |> Map.new()
  end

  defp to_atom(k) when is_atom(k), do: k
  defp to_atom(k) when is_binary(k), do: String.to_atom(k)
end
