defmodule AuthApi.Repo do
  use Ecto.Repo,
    otp_app: :auth_api,
    adapter: Ecto.Adapters.Postgres
end
