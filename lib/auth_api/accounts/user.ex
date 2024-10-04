defmodule AuthApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  @derive {Jason.Encoder, only: [:id, :username, :inserted_at, :updated_at]}
  schema "users" do
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
    |> hash_password()
  end

  @doc false
  def change_username_changeset(%AuthApi.Accounts.User{} = user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    end
  end
end
