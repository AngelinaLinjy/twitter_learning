defmodule Twitter.TwittersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Twitter.Twitters` context.
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
      |> Twitter.Twitters.create_post()

    post
  end
end
