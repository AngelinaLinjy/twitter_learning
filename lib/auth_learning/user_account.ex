defmodule AuthLearning.UserAccount do
  alias AuthLearning.Account.User
  alias AuthLearning.Repo
  alias AuthLearning.Account.UserToken
  alias AuthLearning.Account.Follows
  alias AuthLearning.Twitters.Like

  import Ecto.Query

  @rand_size 32
  @log_in_session_token "log_in_session_token"
  @log_in_session_token_expired_days 1

  def get!(id) do
    User
    |> Repo.get!(id)
  end

  def is_following?(follower_id, followed_id) do
    query =
      from(f in Follows,
        where: f.follower_id == ^follower_id and f.followed_id == ^followed_id,
        select: count(f.id)
      )

    case Repo.one(query) do
      count when count > 0 -> true
      _ -> false
    end
  end

  def user_followings(user_id) do
    from(u in User,
      where: u.id == ^user_id,
      join: f in Follows,
      on: f.follower_id == u.id,
      select: count(f.followed_id)
    )
    |> Repo.one()
  end

  def user_followers(user_id) do
    from(u in User,
      where: u.id == ^user_id,
      join: f in Follows,
      on: f.followed_id == u.id,
      select: count(f.follower_id)
    )
    |> Repo.one()
  end

  def create_following(follower_id, followed_id) do
    %Follows{}
    |> Follows.changeset(%{follower_id: follower_id, followed_id: followed_id})
    |> Repo.insert()
  end

  def fetch_following_list(user_id) do
    from(u in User,
      join: f in Follows,
      on: f.followed_id == u.id,
      where: f.follower_id == ^user_id
    )
    |> Repo.all()
  end

  def fetch_follower_list(user_id) do
    from(u in User,
      join: f in Follows,
      on: f.follower_id == u.id,
      where: f.followed_id == ^user_id
    )
    |> Repo.all()
  end

  def get_user_by_email_and_password(email, password) do
    User
    |> where(email: ^email, password: ^password)
    |> Repo.one()
  end

  def registrate_user(attrs) do
    {:ok, binary_data} = File.read(attrs[:avatar].path)
    attrs = Map.put(attrs, :avatar, binary_data)

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def gen_log_in_session_token(user_id) do
    token = :crypto.strong_rand_bytes(@rand_size)
    user = Repo.get(User, user_id)

    token = %UserToken{token: token, context: @log_in_session_token, user_id: user.id}

    token
    |> Repo.insert(
      conflict_target: [:context, :user_id],
      on_conflict: {:replace, [:token, :inserted_at, :updated_at]}
    )
  end

  def verify_user_by_session_token(nil), do: nil

  def verify_user_by_session_token(token) do
    token =
      from(t in UserToken,
        where:
          t.token == ^token and
            t.context ==
              @log_in_session_token and
            t.inserted_at > ago(@log_in_session_token_expired_days, "day"),
        select: t
      )
      |> Repo.one()

    get_user_by_token(token)
  end

  def get_user_by_token(nil), do: nil

  def get_user_by_token(token) do
    Repo.get(User, token.user_id)
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def update(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def liked?(user_id, post_id) do
    Repo.exists?(from l in Like, where: l.user_id == ^user_id and l.post_id == ^post_id)
  end
end
