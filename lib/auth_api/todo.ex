defmodule AuthApi.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :description, :string
    field :title, :string
    field :completed, :boolean, default: false
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :completed])
    |> validate_required([:title, :description, :completed])
  end
end
