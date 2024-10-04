defmodule AuthApi.Accounts.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:title, :description, :completed, :inserted_at, :updated_at]} #eğer her işlemde user dönmesini istiyorsan :user ekle
  schema "todos" do
    field :title, :string
    field :description, :string
    field :completed, :boolean, default: false
    belongs_to :user, AuthApi.Accounts.User

    timestamps()
  end

  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :completed, :user_id])
    |> validate_required([:title, :user_id])
  end
end
