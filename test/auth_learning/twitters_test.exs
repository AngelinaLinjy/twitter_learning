defmodule AuthLearning.TwittersTest do
  use AuthLearning.DataCase

  alias AuthLearning.Twitters

  describe "posts" do
    alias AuthLearning.Twitters.Post

    import AuthLearning.TwittersFixtures

    @invalid_attrs %{body: nil, subject: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Twitters.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Twitters.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{body: "some body", subject: "some subject"}

      assert {:ok, %Post{} = post} = Twitters.create_post(valid_attrs)
      assert post.body == "some body"
      assert post.subject == "some subject"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Twitters.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{body: "some updated body", subject: "some updated subject"}

      assert {:ok, %Post{} = post} = Twitters.update_post(post, update_attrs)
      assert post.body == "some updated body"
      assert post.subject == "some updated subject"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Twitters.update_post(post, @invalid_attrs)
      assert post == Twitters.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Twitters.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Twitters.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Twitters.change_post(post)
    end
  end
end
