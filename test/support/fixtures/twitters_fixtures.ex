defmodule AuthLearning.TwittersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AuthLearning.Twitters` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        subject: "some subject"
      })
      |> AuthLearning.Twitters.create_post()

    post
  end
end
