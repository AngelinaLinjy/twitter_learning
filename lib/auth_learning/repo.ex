defmodule AuthLearning.Repo do
  use Ecto.Repo,
    otp_app: :auth_learning,
    adapter: Ecto.Adapters.Postgres
end
