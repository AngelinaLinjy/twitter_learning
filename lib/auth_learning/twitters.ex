defmodule AuthLearning.Twitters do
  @moduledoc """
  The Twitters context.
  """

  import Ecto.Query, warn: false

  alias AuthLearning.Repo
  alias AuthLearning.Twitters.Post
  alias AuthLearning.Twitters.Comment
  alias Phoenix.PubSub

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post) |> Repo.preload(:user)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id),
    do: Repo.get!(Post, id) |> Repo.preload(comment: [:user]) |> Repo.preload(:user)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs) do
    case do_create_post(attrs) do
      {:ok, post} = result ->
        post = Repo.preload(post, :user)
        PubSub.broadcast(AuthLearning.PubSub, "new_post", {:new_post, post})
        result

      other ->
        other
    end
  end

  defp do_create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    post
    |> Repo.preload(:user)
    |> Post.changeset(attrs)
  end

  # Comment

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    comment
    |> Repo.preload(:user)
    |> Repo.preload(:post)
    |> Comment.changeset(attrs)
  end

  @doc """
  Create a comment on a specific post

  # Examples

      iex> create_comment(%{field: value})
      {:ok, %Post{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  alias AuthLearning.Twitters.Like

  @doc """
  Returns the list of likes.

  ## Examples

      iex> list_likes()
      [%Like{}, ...]

  """
  def list_likes do
    Repo.all(Like)
  end

  @doc """
  Gets a single like.

  Raises `Ecto.NoResultsError` if the Like does not exist.

  ## Examples

      iex> get_like!(123)
      %Like{}

      iex> get_like!(456)
      ** (Ecto.NoResultsError)

  """
  def get_like!(id), do: Repo.get!(Like, id)

  @doc """
  Creates a like.

  ## Examples

      iex> create_like(%{field: value})
      {:ok, %Like{}}

      iex> create_like(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_like(attrs \\ %{}) do
    %Like{}
    |> Like.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a like.

  ## Examples

      iex> update_like(like, %{field: new_value})
      {:ok, %Like{}}

      iex> update_like(like, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_like(%Like{} = like, attrs) do
    like
    |> Like.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a like.

  ## Examples

      iex> delete_like(like)
      {:ok, %Like{}}

      iex> delete_like(like)
      {:error, %Ecto.Changeset{}}

  """
  def delete_like(%{post_id: post_id, user_id: user_id} = _like) do
    like = Repo.get_by(Like, post_id: post_id, user_id: user_id)
    Repo.delete(like)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking like changes.

  ## Examples

      iex> change_like(like)
      %Ecto.Changeset{data: %Like{}}

  """
  def change_like(%Like{} = like, attrs \\ %{}) do
    Like.changeset(like, attrs)
  end

  def count_likes(post_id) do
    from(l in Like, where: l.post_id == ^post_id)
    |> Repo.aggregate(:count)
  end
end
