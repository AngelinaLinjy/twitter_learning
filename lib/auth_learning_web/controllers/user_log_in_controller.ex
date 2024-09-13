defmodule AuthLearningWeb.UserLogInController do
  use AuthLearningWeb, :controller

  def new(conn, _params) do
    render(conn, :new)
  end
end
