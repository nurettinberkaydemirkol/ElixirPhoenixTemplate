defmodule AuthApi.Accounts.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do  # Dikkat: "todo" değil "todos"
    field :title, :string
    field :description, :string
    field :completed, :boolean, default: false  # Boole olarak değiştirildi
    belongs_to :user, AuthApi.Accounts.User

    timestamps()
  end

  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :completed, :user_id])
    |> validate_required([:title, :user_id])
  end
end
